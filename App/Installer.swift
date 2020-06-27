import Foundation
import Combine

public enum State: Equatable {
    case login
    case busy(value: Progress)
    case complete
    func onlyProgress() -> Progress? {
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

public struct HTTPLoginResponseSuccess: Codable {
    public let message: HTTPLoginMessage
    public let vernalFallsConfig: [String: String]
    public let org: Organization
}

public struct HTTPLoginResponseFailure: Codable {
    public let error: String
}

public enum HTTPLoginServerResponse: Codable {
    public init(from decoder: Decoder) throws {
        if let works = try? HTTPLoginServerResponse.success(value:HTTPLoginResponseSuccess(from: decoder)) {
            self = works
        } else {
            self = try HTTPLoginServerResponse.failure(value:HTTPLoginResponseFailure(from: decoder))
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
    
    case success(value:HTTPLoginResponseSuccess)
    case failure(value:HTTPLoginResponseFailure)
}

struct HTTPLoginResponse: Codable {
    let message: HTTPLoginMessage?
    let vernalFallsConfig: [String: String]?
    let org: Organization?
    let error: String?
}

public struct HTTPLoginMessage: Codable {
    let downloadUrl: URL
    let vernalFallsVersion: String
}

public class Installer: NSObject {
    public static let shared = Installer()
    @Published public var state: State = .login
    @objc func downloadStep() {
        if case let .busy(value: value) = state {
            if value.isFinished {
                state = .complete
            } else {
                value.completedUnitCount += 1
                state = .busy(value: value)
                perform(#selector(downloadStep), with: nil, afterDelay: 0.1)
            }
        }
    }
    @objc func downloadStart() {
        let progress = Progress()
        progress.isCancellable = true
        progress.totalUnitCount = 20
        progress.completedUnitCount = 1
        self.state = .busy(value: progress)
        perform(#selector(downloadStep), with: nil, afterDelay: 1)
    }
    var cancellables = Set<AnyCancellable>()
    
    func handle(response: HTTPLoginMessage) {
        print(response)
    }
    
    enum ApiError: Error {
        case server(message: String)
    }

    public func beginInstallation(login: Login) {
        let backend = BackEnd(rawValue: login.environment)!
        
        let loginUrl = backend.baseUrl().appendingPathComponent("api/app-setup")
        var components = URLComponents(url: loginUrl, resolvingAgainstBaseURL: true)!
        components.queryItems = [.init(name: "email", value: login.username),
                                 .init(name: "password", value: login.password),
                                 .init(name: "client-id", value: "delete-me-please-test")]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: request)
        .map { $0.data }
        .decode(type: HTTPLoginResponse.self, decoder: JSONDecoder())
        .tryMap { response -> HTTPLoginMessage in
                if let error = response.error {
                    throw ApiError.server(message: error)
                }
                return response.message!
        }
        .eraseToAnyPublisher()
        
        remoteDataPublisher.sink(receiveCompletion: { complete in
            print(complete)
        }) { response in
            self.handle(response: response)
        }.store(in: &cancellables)
        
        assert(state == .login)
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .receiving
        progress.isCancellable = false
        state = .busy(value: progress)
        perform(#selector(downloadStart), with: nil, afterDelay: 1)
    }
    public func cancelInstallation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let progress = Progress()
        progress.isCancellable = false
        state = .busy(value: progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.state = .login
        }
    }
    public func uninstall() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let progress = Progress()
        progress.isCancellable = false
        state = .busy(value: progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state = .login
        }
    }
}

extension Installer: Installation {
    public var statePublisher: AnyPublisher<State, Never> {
        $state.eraseToAnyPublisher()
    }
}
