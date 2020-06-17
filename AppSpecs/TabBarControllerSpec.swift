import Quick
import Nimble

class TabBarControllerSpec: QuickSpec {
    override func spec() {
        describe("TabBarController") {
            context("awakeFromNib") {
                var mainWindow: NSWindow!
                beforeEach {
                    mainWindow = NSApp.orderedWindows.first!
                }
                it("should be content view controller") {
                    expect(mainWindow.contentViewController).to(beAKindOf(NSTabViewController.self))
                }
            }
        }
    }
}
