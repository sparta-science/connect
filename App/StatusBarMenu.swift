import AppKit

public class StatusBarMenu: NSMenu {
    public let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func setupButton() {
        let first = item(at: 0)!
        removeItem(first)
        let button = statusItem.button
        button?.image = first.image
        button?.title = first.title
        button?.setAccessibilityIdentifier(first.accessibilityIdentifier())
    }
    func setupStatusItem() {
        statusItem.menu = self
        statusItem.autosaveName = Bundle.main.bundleIdentifier
        statusItem.behavior = [.terminationOnRemoval, .removalAllowed]
        setupButton()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupStatusItem()
    }
}
