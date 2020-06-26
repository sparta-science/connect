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
                case .login:
                    self.selectedTabViewItemIndex = 0
                case .progress:
                    self.selectedTabViewItemIndex = 1
                case .complete:
                    self.selectedTabViewItemIndex = 2
                }
            })
            .store(in: &cancellables)
    }
}
