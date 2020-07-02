import AppKit
import Combine

public class Installer: NSObject {
    @Published public var state: State = .login
    var cancellables = Set<AnyCancellable>()
    @Inject var errorReporter: ErrorReporting
    @Inject("installation url")
    var installationURL: URL
    @Inject var fileManager: FileManager
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

    public func makeRequest(_ request: URLRequest) {
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .receiving
        progress.isCancellable = true
        state = .busy(value: progress)

        URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: HTTPLoginResponse.self, decoder: JSONDecoder())
            .tryMap { response -> HTTPLoginMessage in
                try self.prepareLocation()
                switch response {
                case .failure(value: let serverError):
                    throw ApiError.server(message: serverError.error)
                case .success(value: let success):
                    //                self.process(success.org)
                    try self.writeVernalFallsConfig(dictionary: success.vernalFallsConfig)
                    return success.message
                }
            }
        .sink(receiveCompletion: { complete in
            switch complete {
            case .finished:
                print("Finished")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.cancelInstallation()
                    self.errorReporter.report(error: error)
                }
                print("failure error: ", error)
            }
        }, receiveValue: { response in
            print("final response: ", response)
            self.state = .complete
        })
        .store(in: &cancellables)
    }

    public func beginInstallation(login: Login) {
        assert(state == .login)
        makeRequest(loginRequest(login))
    }

    public func cancelInstallation() {
        cancellables.forEach { $0.cancel() }
        state = .login
    }

    public func uninstall() {
        state = .login
    }
}
