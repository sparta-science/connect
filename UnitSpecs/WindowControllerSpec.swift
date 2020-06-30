import Nimble
import Quick
import Testable

class WindowControllerSpec: QuickSpec {
    override func spec() {
        describe(WindowController.self) {
            var mockApp: MockApplication!
            var subject: WindowController!
            beforeEach {
                mockApp = .createAndInject()
                subject = .init()
            }
            context(WindowController.showWindow) {
                beforeEach {
                    subject.showWindow(nil)
                }
                it("should show window and activate app") {
                    expect(mockApp.didSetPolicy) == .regular
                    expect(mockApp.didActivateWithFlag) == true
                }
            }
            context(NSWindowDelegate.self) {
                context(WindowController.windowWillClose) {
                    beforeEach {
                        subject.windowWillClose(
                            .init(name: NSWindow.willCloseNotification)
                        )
                    }
                    it("should hide app and not activate") {
                        expect(mockApp.didSetPolicy) == .accessory
                        expect(mockApp.didActivateWithFlag).to(beNil())
                    }
                }
            }
        }
    }
}
