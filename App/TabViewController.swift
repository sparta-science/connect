import Cocoa
import Combine

class TabViewController: NSTabViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Installer.shared.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { state in
                switch state {
                case .complete:
                    self.selectedTabViewItemIndex = 2
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
}
