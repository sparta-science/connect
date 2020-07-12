import AppKit

public class TabViewController: NSTabViewController {
    @Inject var notifier: StateNotifier

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
        notifier.start(receiver: updateSelected(_:))
    }
}
