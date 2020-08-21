import Combine

public protocol HealthCheck {
    func update(complete: @escaping (Bool) -> Void)
}

struct HealthCheckResponse: Decodable {
    let websocketActive: Bool
}

public class ConnectionMonitor: HealthCheck {
    let url: URL
    public init(url: URL) {
        self.url = url
    }
    var cancellables = Set<AnyCancellable>()
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }

    public func update(complete: @escaping (Bool) -> Void) {
        cancellables.removeAll()
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: HealthCheckResponse.self, decoder: decoder)
            .tryMap { $0.websocketActive }
            .receive(on: DispatchQueue.main)
            .catch { _ in Just(false) }
            .sink { complete($0) }
            .store(in: &cancellables)
    }
}
