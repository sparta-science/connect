import Cocoa

public class ConnectedController: NSViewController {
    @Inject var installer: Installation

    @IBAction public func disconnect(_ sender: NSButton) {
        installer.uninstall()
    }
}
