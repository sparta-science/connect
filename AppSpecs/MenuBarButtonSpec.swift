import Quick
import Nimble
import SpartaConnect

class MenuBarButtonSpec: QuickSpec {
    override func spec() {
        describe("MenuBarButton") {
            var subject: MenuBarButton!
            var statusMenu: NSMenu!
            beforeEach {
                subject = .init()
                statusMenu = .init(title: "test menu")
                subject.menu = statusMenu
            }
            context("awakeFromNib") {
                context("statusItem") {
                    var statusItem: NSStatusItem!
                    beforeEach {
                        subject.awakeFromNib()
                        statusItem = subject.statusItem
                    }
                    it("should have take main menu from subject") {
                        expect(statusItem.menu) === statusMenu
                    }
                    it("should have correct properties") {
                        expect(statusItem.button?.image) == #imageLiteral(resourceName: "menu-bar-icon")
                        expect(statusItem.isVisible) == true
                        expect(statusItem.behavior) == [.terminationOnRemoval, .removalAllowed]
                        expect(statusItem.autosaveName) == Bundle.main.bundleIdentifier
                        expect(statusItem.length) == NSStatusItem.squareLength
                    }
                }
            }
        }
    }
}
