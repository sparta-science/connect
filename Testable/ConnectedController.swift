import Cocoa

public class ConnectedController: NSViewController {
    @Inject var installer: Installation
    @Inject var forcePlateDetector: ForcePlateDetection
    @IBOutlet public var forcePlateName: NSTextField!
    @Inject var healthCheck: HealthCheck
    @IBOutlet public var connectionStatus: NSTextField!
    public var timer: Timer?

    override public func viewDidLoad() {
        super.viewDidLoad()
        forcePlateDetector.start { [weak self] name in
            self?.forcePlateName.stringValue = name ?? "unplugged"
        }
    }

    func updateStatus(connected: Bool) {
        connectionStatus.stringValue = connected ? "🟢 online" : "🔴 offline"
        timer = .scheduledTimer(timeInterval: 1.0,
                                target: self,
                                selector: #selector(updateConnectedStatus),
                                userInfo: nil,
                                repeats: false)
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
        timer?.invalidate()
    }

    @IBAction public func disconnect(_ sender: NSButton) {
        installer.uninstall()
    }
}
