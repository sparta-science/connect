import AppKit
import Combine

public class Installer: NSObject {
    @Published public var state: State = .login
    var cancellables = Set<AnyCancellable>()
    @Inject var errorReporter: ErrorReporting
    @Inject("installation url")
    var installationURL: URL
    @Inject var fileManager: FileManager
    @Inject var downloader: Downloading
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

    public enum ApiError: LocalizedError {
        case server(message: String)
        public var errorDescription: String? {
            switch self {
            case let .server(message):
                return message
            }
        }
    }

    private func prepareLocation() throws {
        try fileManager.createDirectory(at: installationURL,
                                        withIntermediateDirectories: true)
    }

    func download(url: URL) -> AnyPublisher<URL, Error> {
        downloader.createDownload(url: url, reporting: downloading(_:))
    }

    func downloadUrl() -> URL {
        installationURL.appendingPathComponent("vernal_falls.tar.gz")
    }

    func downloading(_ progress: Progress) {
        if case .busy = state {
            state = .busy(value: progress)
        }
    }

    public func beginInstallation(login: LoginRequest) {
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .receiving
        progress.isCancellable = true
        state = .busy(value: progress)

        URLSession.shared
            .dataTaskPublisher(for: loginRequest(login))
            .map { $0.data }
            .decode(type: HTTPLoginResponse.self, decoder: JSONDecoder())
            .tryMap { response -> HTTPLoginMessage in
                switch response {
                case .failure(value: let serverError):
                    throw ApiError.server(message: serverError.error)
                case .success(value: let success):
                    //                self.process(success.org)
                    try self.prepareLocation()
                    try self.writeVernalFallsConfig(dictionary: success.vernalFallsConfig)
                    return success.message
                }
            }
        .flatMap { self.download(url: $0.downloadUrl) }
        .tryMap {
            try? self.fileManager.removeItem(at: self.downloadUrl())
            try self.fileManager.moveItem(at: $0, to: self.downloadUrl())
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: when(complete:)) { _ in }
        .store(in: &cancellables)
    }

    private func when(complete: Subscribers.Completion<Error>) {
        switch complete {
        case .finished:
            state = .complete
        case .failure(let error):
            cancelInstallation()
            errorReporter.report(error: error)
        }
    }

    public func cancelInstallation() {
        cancellables.forEach { $0.cancel() }
        state = .login
    }

    public func uninstall() {
        state = .login
    }
}
