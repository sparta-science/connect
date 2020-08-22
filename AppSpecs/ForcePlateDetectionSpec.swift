import Nimble
import Quick
import Testable

class ForcePlateDetectionSpec: QuickSpec {
    override func spec() {
        describe(ForcePlateDetection.self) {
            var subject: ForcePlateDetection!
            var center: NotificationCenter!
            beforeEach {
                subject = Injected.instance
                center = Injected.instance
            }
            context("removed") {
                it("should set force plate name to nil") {
                    waitUntil { done in
                        subject.start { forcePlate in
                            expect(forcePlate).to(beNil())
                            done()
                        }
                        center.post(name: Notification.Name("SerialDeviceRemoved"),
                                    object: nil)
                    }
                }
            }
        }
    }
}
