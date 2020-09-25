import Combine

public protocol HealthCheck {
    func start(updating: @escaping (Bool) -> Void)
    func cancel()
}

struct HealthCheckResponse: Decodable {
    let websocketActive: Bool
}

public class ConnectionMonitor {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
    var cancellables = Set<AnyCancellable>()
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }

    func checkHealth() -> AnyPublisher<Bool, Never> {
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
    public func cancel() {
        cancellables.removeAll()
    }

    public func start(updating: @escaping (Bool) -> Void) {
        cancel()
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map { _ in }
            .flatMap(checkHealth)
            .sink(receiveValue: updating)
            .store(in: &cancellables)
    }
}
