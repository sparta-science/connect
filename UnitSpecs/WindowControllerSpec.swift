import Quick
import Nimble
import Testable

class WindowControllerSpec: QuickSpec {
    override func spec() {
        describe(WindowController.self) {
            var mockApp: MockApplication!
            var subject: WindowController!
            beforeEach {
                mockApp = .init()
                subject = Init(.init()) { $0.app = mockApp }
            }
            context(WindowController.showWindow) {
                it("should show window and activate app") {
                    subject.showWindow(nil)
                    expect(mockApp.didSetPolicy) == .regular
                }
            }
            context(NSWindowDelegate.self) {
                context(WindowController.windowWillClose) {
                    beforeEach {
                        let note = Notification(name: NSWindow.willCloseNotification)
                        subject.windowWillClose(note)
                    }
                    it("should hide app") {
                        expect(mockApp.didSetPolicy) == .accessory
                    }
                }
            }
        }
    }
}
