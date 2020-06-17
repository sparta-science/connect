import Quick
import Nimble

class TabBarControllerSpec: QuickSpec {
    override func spec() {
        describe("MainWindow") {
            context("awakeFromNib") {
                var mainWindow: NSWindow!
                beforeEach {
                    mainWindow = NSApp.orderedWindows.first!
                }
                it("should be content view controller") {
                    expect(mainWindow.contentViewController).to(beAKindOf(NSTabViewController.self))
                }
                context("tabViewController") {
                    var tabController: NSTabViewController!
                    beforeEach {
                        tabController = mainWindow.contentViewController as? NSTabViewController
                    }
                    it("should have three tabs") {
                        expect(tabController?.tabViewItems).to(haveCount(3))
                    }
                }
            }
        }
    }
}
