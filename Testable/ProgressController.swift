import AppKit

public class ProgressController: NSViewController {
    @Inject var installer: Installation
    @Inject var notifier: StateNotifier

    @IBOutlet public var progressIndicator: NSProgressIndicator!
    @IBOutlet public var cancelButton: NSButton!
    @IBOutlet public var progressLabel: NSTextField!
    @IBAction public func cancelInstallation(_ sender: NSButton) {
        installer.cancelInstallation()
    }

    private func update(progress: Progress) {
        cancelButton.isHidden = !progress.isCancellable
        progressIndicator.doubleValue = progress.fractionCompleted
        progressIndicator.isIndeterminate = progress.isIndeterminate
        progressIndicator.startAnimation(nil)
        progressLabel.stringValue = progress.localizedDescription
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        notifier.start {
            $0.progress().flatMap { self.update(progress: $0) }
        }
    }
}
