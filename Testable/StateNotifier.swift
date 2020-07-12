import Combine

open class MainThreadNotifier<T> {
    public init() {}
    @Inject var statePublisher: AnyPublisher<T, Never>
    var cancellables = Set<AnyCancellable>()
    open func start(receiver: @escaping (T) -> Void) {
        statePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: receiver)
            .store(in: &cancellables)
    }
}

open class StateNotifier: MainThreadNotifier<State> {}
