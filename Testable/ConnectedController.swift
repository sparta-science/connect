import Cocoa

public class ConnectedController: NSViewController {
    @Inject var installer: Installation
    @Inject var forcePlateDetector: ForcePlateDetection
    @IBOutlet public var forcePlateName: NSTextField!

    override public func viewDidLoad() {
        super.viewDidLoad()
        forcePlateDetector.onChange { [weak self] name in
            self?.forcePlateName.stringValue = name ?? "unplugged"
        }
    }

    @IBAction public func disconnect(_ sender: NSButton) {
        installer.uninstall()
    }
}
