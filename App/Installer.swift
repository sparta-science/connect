import Foundation
import Combine
import AppKit
import Alamofire

public enum State: Equatable {
    case login
    case busy(value: Progress)
    case complete
    func progress() -> Progress? {
        if case let .busy(value: progress) = self {
            return progress
        } else {
            return nil
        }
    }
}

public protocol Installation {
    var statePublisher: AnyPublisher<State, Never> {get}
    func beginInstallation(login: Login)
    func cancelInstallation()
    func uninstall()
}

enum BackEnd: String {
    case localhost
    case staging
    case production
    func baseUrl() -> URL {
        let environment: [BackEnd: String] = [
            .localhost: "http://localhost:4000",
            .staging: "https://staging.spartascience.com",
            .production: "https://home.spartascience.com",
        ]
        return URL(string: environment[self]!)!
    }
}

public struct Organization: Codable {
    let id: Int
    let logoUrl: String?
    let name: String
    let touchIconUrl: String?
}

public struct ResponseSuccess: Codable {
    public let message: HTTPLoginMessage
    public let vernalFallsConfig: [String: String]
    public let org: Organization
}

public struct ResponseFailure: Codable {
    public let error: String
}

public enum HTTPLoginResponse: Codable {
    public init(from decoder: Decoder) throws {
        if let decoded = try? Self.success(ResponseSuccess(from: decoder)) {
            self = decoded
        } else {
            self = try Self.failure(ResponseFailure(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .success(value: let success):
            try success.encode(to: encoder)
        case .failure(value: let failure):
            try failure.encode(to: encoder)
        }
    }
    
    case success(_:ResponseSuccess)
    case failure(_:ResponseFailure)
}

public struct HTTPLoginMessage: Codable {
    let downloadUrl: URL
    let vernalFallsVersion: String
}

public class Installer: NSObject {
    public static let shared = Installer()
    @Published public var state: State = .login
    var cancellables = Set<AnyCancellable>()
    
    enum ApiError: LocalizedError {
        case server(message: String)
        var errorDescription: String? {
            switch self {
            case let .server(message):
                return message
            }
        }
    }
    
    func loginRequest(_ login: Login) -> URLRequest {
        let backend = BackEnd(rawValue: login.environment)!
        let loginUrl = backend.baseUrl().appendingPathComponent("api/app-setup")
        var components = URLComponents(url: loginUrl, resolvingAgainstBaseURL: true)!
        components.queryItems = [.init(name: "email", value: login.username),
                                 .init(name: "password", value: login.password),
                                 .init(name: "client-id", value: "delete-me-please-test")]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        return request
    }
    
    func process(_ org: Organization) {
        print("org:", org)
    }

    public func installationURL() -> URL {
        applicationSupportURL().appendingPathComponent(Bundle.main.bundleIdentifier!)
    }
    public func applicationSupportURL() -> URL {
        FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last!
    }

    func process(_ vernalFallsConfig: [String: String]) {
        print("vernalFallsConfig: ", vernalFallsConfig)
    }
    
    func downloadUrl() -> URL {
        installationURL().appendingPathComponent("vernal_falls.tar.gz")
    }
    
    func downloading(_ progress: Progress) {
        state = .busy(value: progress)
    }
    
    func downloadDestination() -> (destinationURL: URL, options: DownloadRequest.Options) {
        (
            destinationURL: self.downloadUrl(),
            options: [.createIntermediateDirectories, .removePreviousFile]
        )
    }
    
    func destination(_ temporaryURL: URL, _ response: HTTPURLResponse)
        -> (destinationURL: URL, options: DownloadRequest.Options) {
            print("download status: \(response.statusCode)")
            print("download temp file: \(temporaryURL.path)")
            return downloadDestination()
    }
    
    func futureDownload(url: URL) -> Future<URL?, AFError> {
        Future<URL?, AFError> { promise in
            AF.download(url, to: self.destination(_:_:))
                .response { promise($0.result) }
                .downloadProgress(closure: self.downloading(_:))
        }
    }
    
    func createDownload(url: URL) -> AnyPublisher<URL, Error> {
        futureDownload(url: url)
        .compactMap {$0}
        .mapError {$0}
        .eraseToAnyPublisher()
    }

    public func beginInstallation(login: Login) {
        assert(state == .login)
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
            try FileManager.default.createDirectory(at: self.installationURL(),
                                                    withIntermediateDirectories: true)
            switch response {
            case .failure(value: let serverError):
                throw ApiError.server(message: serverError.error)
            case .success(value: let success):
                self.process(success.org)
                self.process(success.vernalFallsConfig)
                return success.message
            }
        }
        .flatMap {
            self.createDownload(url: $0.downloadUrl)
        }.sink(receiveCompletion: { complete in
            switch complete {
            case .finished:
                print("Finished")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.cancelInstallation()
                    NSAlert(error: error).runModal()
                }
                print("failure error: ", error)
            }
        }) { response in
            print("final response: ", response)
            self.state = .complete
        }.store(in: &cancellables)
    }
    public func cancelInstallation() {
        let progress = Progress()
        progress.isCancellable = false
        state = .busy(value: progress)
        AF.cancelAllRequests()
        cancellables.forEach {
            $0.cancel()
        }
        cancellables.removeAll()
        state = .login
    }
    public func uninstall() {
        let progress = Progress()
        progress.isCancellable = false
        state = .busy(value: progress)
        try? FileManager.default.removeItem(at: installationURL())
        state = .login
    }
}

extension Installer: Installation {
    public var statePublisher: AnyPublisher<State, Never> {
        $state.eraseToAnyPublisher()
    }
}
