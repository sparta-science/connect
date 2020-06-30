import Quick
import Nimble
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
                }
            }
            context(NSWindowDelegate.self) {
                context(WindowController.windowWillClose) {
                    beforeEach {
                        subject.windowWillClose(
                            .init(name: NSWindow.willCloseNotification)
                        )
                    }
                    it("should hide app") {
                        expect(mockApp.didSetPolicy) == .accessory
                    }
                }
            }
        }
    }
}
