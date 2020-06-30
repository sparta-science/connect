import Cocoa

public class ProgressController: NSViewController {
    @IBOutlet public var progressIndicator: NSProgressIndicator!
    @IBOutlet public var cancelButton: NSButton!
    @IBOutlet public var progressLabel: NSTextField!
    @IBAction public func cancelInstallation(_ sender: NSButton) {
    }
}
