import AppKit
import Combine

public class Installer: NSObject {
    var cancellables = Set<AnyCancellable>()
    @Inject var errorReporter: ErrorReporting
    @Inject("installation url")
    var installationURL: URL
    @Inject("installation script url")
    var scriptURL: URL
    @Inject var fileManager: FileManager
    @Inject var downloader: Downloading
    @Inject var stateContainer: StateContainer
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

    func downloading(_ progress: Progress) {
        // TODO: use method on container
        if case .busy = stateContainer.state {
            stateContainer.state = .busy(value: progress)
        }
    }

    public func beginInstallation(login: LoginRequest) {
        stateContainer.startReceiving()

        URLSession.shared
            .dataTaskPublisher(for: loginRequest(login))
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
                                  reporting: downloading(_:))
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
            //                self.process(success.org)
            try prepareLocation()
            try writeVernalFallsConfig(dictionary: success.vernalFallsConfig)
            return success.message
        }
    }

    private func when(complete: Subscribers.Completion<Error>) {
        switch complete {
        case .finished:
            // TODO: use method on container
            stateContainer.state = .complete
        case .failure(let error):
            cancelInstallation()
            errorReporter.report(error: error)
        }
    }

    public func cancelInstallation() {
        cancellables.forEach { $0.cancel() }
        // TODO: use method on container
        stateContainer.state = .login
    }

    public func uninstall() {
        // TODO: use method on container
        stateContainer.state = .login
    }
}
