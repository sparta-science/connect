import Cocoa

class ConnectedController: NSViewController {
    @IBAction func disconnect(_ sender: NSButton) {
        Installer.shared.uninstall()
    }
}

