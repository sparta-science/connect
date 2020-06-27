import Cocoa
import Combine

public class ProgressController: NSViewController {
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var cancelButton: NSButton!
    @IBAction func cancelInstallation(_ sender: NSButton) {
        Installer.shared.cancelInstallation()
    }
    @IBOutlet weak var progressLabel: NSTextField!
    var cancellables = Set<AnyCancellable>()
    
    func update(progress: Progress) {
        cancelButton.isHidden = !progress.isCancellable
        progressIndicator.doubleValue = 100 * progress.fractionCompleted
        progressIndicator.isIndeterminate = progress.isIndeterminate
        progressIndicator.startAnimation(nil)
        progressLabel.stringValue = progress.localizedDescription
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        Installer.shared.$state
            .receive(on: DispatchQueue.main)
            .compactMap {$0.onlyProgress()}
            .sink { self.update(progress: $0) }
            .store(in: &cancellables)
    }
}
