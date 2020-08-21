import Cocoa

protocol HealthCheck {
    func update(complete: (Bool) -> Void)
}

public class ConnectedController: NSViewController {
    @Inject var installer: Installation
    @Inject var forcePlateDetector: ForcePlateDetection
    @IBOutlet public var forcePlateName: NSTextField!
    @Inject var healthCheck: HealthCheck

    override public func viewDidLoad() {
        super.viewDidLoad()
        forcePlateDetector.start { [weak self] name in
            self?.forcePlateName.stringValue = name ?? "unplugged"
        }
    }

    @objc func updateConnectedStatus() {
        healthCheck.update { connected in
            forcePlateName.stringValue = connected ? "connected" : "not"
            perform(#selector(updateConnectedStatus), with: nil, afterDelay: 1.0)
        }
    }

    override public func viewDidAppear() {
        super.viewDidAppear()
        updateConnectedStatus()
    }

    override public func viewDidDisappear() {
        super.viewDidDisappear()
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(updateConnectedStatus),
                                               object: nil)
    }

    @IBAction public func disconnect(_ sender: NSButton) {
        installer.uninstall()
    }
}
