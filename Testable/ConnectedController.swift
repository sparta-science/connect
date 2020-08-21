import Cocoa

public class ConnectedController: NSViewController {
    @Inject var installer: Installation
    @Inject var forcePlateDetector: ForcePlateDetection
    @IBOutlet public var forcePlateName: NSTextField!
    @Inject var healthCheck: HealthCheck
    @IBOutlet public var connectionStatus: NSTextField!

    override public func viewDidLoad() {
        super.viewDidLoad()
        forcePlateDetector.start { [weak self] name in
            self?.forcePlateName.stringValue = name ?? "unplugged"
        }
    }

    func updateStatus(connected: Bool) {
        connectionStatus.stringValue = connected ? "connected" : "not connected"
        perform(#selector(updateConnectedStatus), with: nil, afterDelay: 1.0)
    }

    @objc func updateConnectedStatus() {
        healthCheck.update { [weak self] connected in
            self?.updateStatus(connected: connected)
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
