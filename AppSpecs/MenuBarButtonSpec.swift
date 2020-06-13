import Quick
import Nimble
import SpartaConnect

class MenuBarButtonSpec: QuickSpec {
    override func spec() {
        describe("MenuBarButton") {
            var subject: MenuBarButton!
            beforeEach {
                subject = .init()
            }
            context("awakeFromNib") {
                var mainMenu: NSMenu!
                beforeEach {
                    mainMenu = .init(title: "test menu")
                    NSApp.mainMenu = mainMenu
                }
                context("statusItem") {
                    var statusItem: NSStatusItem!
                    beforeEach {
                        subject.awakeFromNib()
                        statusItem = subject.statusItem
                    }
                    it("should have take main menu and clear it") {
                        expect(statusItem.menu) === mainMenu
                        expect(NSApp.mainMenu).to(beNil())
                    }
                    it("should have correct properties") {
                        expect(statusItem.button?.image) == #imageLiteral(resourceName: "menu-bar-icon")
                        expect(statusItem.isVisible) == true
                        expect(statusItem.behavior) == [.terminationOnRemoval, .removalAllowed]
                        expect(statusItem.autosaveName) == Bundle.main.bundleIdentifier
                        expect(statusItem.length) == -2.0
                    }
                }
            }
        }
    }
}
