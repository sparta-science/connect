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
                it("should be a view controller") {
                    expect(mainWindow.contentViewController)
                        .to(beAKindOf(NSViewController.self))
                }
                context("tabViewController") {
                    var tabController: NSTabViewController!
                    beforeEach {
                        tabController = mainWindow
                            .contentViewController?
                            .children
                            .first as? NSTabViewController
                    }
                    it("should have three tabs") {
                        expect(tabController?.tabViewItems).to(haveCount(3))
                    }
                }
            }
        }
    }
}
