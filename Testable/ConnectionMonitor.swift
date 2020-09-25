import Combine

public protocol HealthCheck {
    func checkHealth(every: TimeInterval) -> AnyPublisher<Bool, Never>
}

struct HealthCheckResponse: Decodable {
    let websocketActive: Bool
}

public class ConnectionMonitor {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }

    func startCheck() -> AnyPublisher<Bool, Never> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: HealthCheckResponse.self, decoder: decoder)
            .tryMap { $0.websocketActive }
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty(completeImmediately: true) }
            .eraseToAnyPublisher()
    }
}

extension ConnectionMonitor: HealthCheck {
    public func checkHealth(every time: TimeInterval) -> AnyPublisher<Bool, Never> {
        Timer.publish(every: time, on: .main, in: .common)
            .autoconnect()
            .map { _ in }
            .flatMap(startCheck)
            .merge(with: startCheck())
            .eraseToAnyPublisher()
    }
}
