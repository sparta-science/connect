import AppKit

public class MenuBarButton: NSObject {
    public var statusItem: NSStatusItem!

    public override func awakeFromNib() {
        super.awakeFromNib()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.menu = NSApp.mainMenu
        statusItem.autosaveName = Bundle.main.bundleIdentifier
        statusItem.behavior = [.terminationOnRemoval, .removalAllowed]
        statusItem.button?.image = #imageLiteral(resourceName: "menu-bar-icon")
        NSApp.mainMenu = nil
    }
}
