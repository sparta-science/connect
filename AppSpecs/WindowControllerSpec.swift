import Quick
import Nimble
import SpartaConnect

class WindowControllerSpec: QuickSpec {
    override func spec() {
        describe("WindowController") {
            var subject: WindowController!
            beforeEach {
                subject = .init()
            }
            context("showMainWindow") {
                it("should show window and activate app") {
                    subject.showMainWindow(nil)
                    expect(NSApp.activationPolicy()) == .regular
                }
            }
            context("NSWindowDelegate") {
                context("windowWillClose") {
                    beforeEach {
                        let note = Notification(name: NSWindow.willCloseNotification)
                        subject.windowWillClose(note)
                    }
                    it("should hide app") {
                        expect(NSApp.activationPolicy()) == .accessory
                    }
                }
            }
        }
    }
}
