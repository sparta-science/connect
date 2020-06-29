import Cocoa

public class WindowController: NSWindowController {
    public override func showWindow(_ sender: Any?) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        super.showWindow(sender)
    }
}

extension WindowController: NSWindowDelegate {
    public func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
