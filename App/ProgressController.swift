import Cocoa
import Combine

public class ProgressController: NSViewController {
    @IBOutlet public var progressIndicator: NSProgressIndicator!
    @IBOutlet public var cancelButton: NSButton!
    public var installer: Installation!
    @IBAction func cancelInstallation(_ sender: NSButton) {
        installer.cancelInstallation()
    }
    @IBOutlet public var progressLabel: NSTextField!
    var cancellables = Set<AnyCancellable>()
    
    func update(progress: Progress) {
        cancelButton.isHidden = !progress.isCancellable
        progressIndicator.doubleValue = progress.fractionCompleted
        progressIndicator.isIndeterminate = progress.isIndeterminate
        progressIndicator.startAnimation(nil)
        progressLabel.stringValue = progress.localizedDescription
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        installer = Installer.shared
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        installer.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap {$0.onlyProgress()}
            .sink { self.update(progress: $0) }
            .store(in: &cancellables)
    }
}
