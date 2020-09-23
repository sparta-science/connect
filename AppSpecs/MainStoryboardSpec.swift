import Nimble
import Quick

class MainStoryboardSpec: QuickSpec {
    override func spec() {
        describe(NSStoryboard.main.self) {
            context("initial controller") {
                var windowController: NSWindowController!
                var window: NSWindow!
                beforeEach {
                    windowController = NSApp.orderedWindows.first!.windowController!
                    window = windowController.window
                }
                context(\NSWindowController.contentViewController) {
                    var container: NSViewController!
                    beforeEach {
                        container = windowController.contentViewController
                    }
                    context("done button") {
                        var doneButton: NSButton!
                        beforeEach {
                            doneButton = container
                                .view
                                .subviews
                                .first { $0.isKind(of: NSButton.self) } as? NSButton
                        }
                        it("should close window") {
                            expect(doneButton.title) == "Done"
                            doneButton.performClick(nil)
                            expect(window.isVisible) == false
                        }
                    }
                    context("tabViewController") {
                        var tabController: NSTabViewController!
                        beforeEach {
                            tabController = container
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
}
