import Cocoa
import Combine

public class ProgressController: NSViewController {
    @Inject var installer: Installation
    @Inject var statePublisher: AnyPublisher<State, Never>
    var cancellables = Set<AnyCancellable>()

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
        statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0.progress() }
            .sink { self.update(progress: $0) }
            .store(in: &cancellables)
    }
}
