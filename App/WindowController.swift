import Cocoa
import Testable

public class WindowController: NSWindowController {
    @Inject var app: ApplicationAdapter
    public override func showWindow(_ sender: Any?) {
        app.setActivationPolicy(.regular)
        app.activate(ignoringOtherApps: true)
        super.showWindow(sender)
    }
}

extension WindowController: NSWindowDelegate {
    public func windowWillClose(_ notification: Notification) {
        app.setActivationPolicy(.accessory)
    }
}
