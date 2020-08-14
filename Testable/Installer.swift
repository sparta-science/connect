import AppKit
import Combine

public class Installer: NSObject {
    var cancellables = Set<AnyCancellable>()
    @Inject var errorReporter: ErrorReporting
    @Inject("installation url") var installationURL: URL
    @Inject("installation script url") var scriptURL: URL
    @Inject var fileManager: FileManager
    @Inject var downloader: Downloading
    @Inject var stateContainer: StateContainer
    @Inject("unique client id") var clientId: String
    @Inject var defaults: UserDefaults
}

extension Installer: Installation {
    public func vernalConfigURL() -> URL {
        installationURL.appendingPathComponent("vernal_falls_config.yml")
    }

    private func writeVernalFallsConfig(dictionary: [String: String]) throws {
        var contents = ""
        dictionary.sorted(by: <).forEach { (key: String, value: String) in
            contents.append(key + ": \"\(value)\"\n")
        }
        let destination = vernalConfigURL()
        try contents.write(to: destination, atomically: true, encoding: .ascii)
    }

    private func prepareLocation() throws {
        try fileManager.createDirectory(at: installationURL,
                                        withIntermediateDirectories: true)
    }

    var downloadUrl: URL {
        installationURL.appendingPathComponent("vernal_falls.tar.gz")
    }

    public func beginInstallation(login: LoginRequest) {
        stateContainer.startReceiving()

        URLSession.shared
            .dataTaskPublisher(for: loginRequest(login, clientId: clientId))
            .map { $0.data }
            .decode(type: HTTPLoginResponse.self, decoder: JSONDecoder())
            .tryMap(transform(response:))
            .flatMap(startDownload(message:))
            .tryMap(process(downloaded:))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: when(complete:)) { _ in }
            .store(in: &cancellables)
    }

    private func installVernalFalls() throws {
        let launcher = ProcessLauncher()
        try launcher.runShellScript(script: scriptURL, in: installationURL)
    }

    private func startDownload(message: HTTPLoginMessage) -> DownloadPublisher {
        downloader.createDownload(url: message.downloadUrl,
                                  reporting: stateContainer.update(progress:))
    }

    private func process(downloaded: URL) throws {
        try? fileManager.removeItem(at: downloadUrl)
        try fileManager.moveItem(at: downloaded, to: downloadUrl)
        try installVernalFalls()
    }

    private func transform(response: HTTPLoginResponse) throws -> HTTPLoginMessage {
        switch response {
        case .failure(value: let serverError):
            throw PresentableError.server(message: serverError.error)
        case .success(value: let success):
            saveOrgName(org: success.org)
            try prepareLocation()
            try writeVernalFallsConfig(dictionary: success.vernalFallsConfig)
            return success.message
        }
    }

    func saveOrgName(org: Organization) {
        (NSUserDefaultsController.shared.values as AnyObject).setValue(org.name, forKey: "org.name")
    }

    private func when(complete: Subscribers.Completion<Error>) {
        switch complete {
        case .finished:
            stateContainer.complete()
        case .failure(let error):
            errorReporter.report(error: error)
            uninstall()
        }
    }

    public func uninstall() {
        cancellables.forEach { $0.cancel() }
        try? fileManager.removeItem(at: installationURL)
        stateContainer.reset()
    }
}
