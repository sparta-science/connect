import Cocoa

public class WindowController: NSWindowController {
    @Inject private var app: ApplicationAdapter
    override public func showWindow(_ sender: Any?) {
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
