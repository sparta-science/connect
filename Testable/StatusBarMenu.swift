import AppKit

public class StatusBarMenu: NSMenu {
    @Inject public var statusItem: NSStatusItem
    @Inject var bundle: Bundle

    private func configure(button: NSStatusBarButton) {
        Configure(item(at: 0)!) { first in
            removeItem(first)
            Configure(button) {
                $0.image = first.image
                $0.title = first.title
                $0.setAccessibilityIdentifier(first.accessibilityIdentifier())
            }
        }
    }
    private func configureStatusItem() {
        Configure(statusItem) {
            $0.menu = self
            $0.autosaveName = bundle.bundleIdentifier
            $0.behavior = [.terminationOnRemoval, .removalAllowed]
            configure(button: $0.button!)
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureStatusItem()
    }
}
