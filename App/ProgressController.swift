import Cocoa

class ProgressController: NSViewController {
    @IBOutlet public var progressIndicator: NSProgressIndicator!
    @IBOutlet public var cancelButton: NSButton!
    @IBOutlet public var progressLabel: NSTextField!
    @IBAction func cancelInstallation(_ sender: NSButton) {
    }
}
