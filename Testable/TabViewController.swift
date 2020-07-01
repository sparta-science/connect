import Cocoa
import Combine

public class TabViewController: NSTabViewController {
    @Inject var statePublisher: AnyPublisher<State, Never>
    var cancellables = Set<AnyCancellable>()

    private func observeState() {
        statePublisher
            .sink(receiveValue: updateSelected(_:))
            .store(in: &cancellables)
    }

    private func updateSelected(_ state: State) {
        selectedTabViewItemIndex = tabIndex(state)
    }
    private func tabIndex(_ state: State) -> Int {
        switch state {
        case .login:
            return 0
        case .busy:
            return 1
        case .complete:
            return 2
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        observeState()
    }
}
