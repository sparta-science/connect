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
            self?.forcePlateName.textColor = name == nil ? .systemRed : .labelColor
        }
    }

    override public func viewDidAppear() {
        super.viewDidAppear()
        connectionStatus.stringValue = "connecting..."
        healthCheck.start { [weak self] connected in
            self?.connectionStatus.stringValue = connected ? "🟢 online" : "🔴 offline"
        }
    }

    override public func viewDidDisappear() {
        super.viewDidDisappear()
        healthCheck.cancel()
    }

    @IBAction public func disconnect(_ sender: NSButton) {
        installer.uninstall()
    }
}
