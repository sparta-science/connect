import Cocoa
import Combine

class ProgressController: NSViewController {
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var cancelButton: NSButton!
    @IBAction func cancelInstallation(_ sender: NSButton) {
        Installer.shared.cancelInstallation()
    }
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Installer.shared.$state.sink { state in
            if case let .progress(value: progress) = state {
                self.cancelButton.isHidden = !progress.isCancellable
                self.progressIndicator.doubleValue = 100 * progress.fractionCompleted
                self.progressIndicator.isIndeterminate = progress.isIndeterminate
                self.progressIndicator.startAnimation(nil)
            }
        }.store(in: &cancellables)
    }
}
