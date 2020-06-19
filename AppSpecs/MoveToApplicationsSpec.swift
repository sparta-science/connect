import Nimble
import Quick
import SpartaConnect

class MoveToApplicationsSpec: QuickSpec {
    override func spec() {
        describe("MoveToApplications") {
            var subject: MoveToApplications!
            beforeEach {
                subject = .init()
            }
            context("awakeFromNib") {
                var center: NotificationCenter!
                let name = NSApplication.didFinishLaunchingNotification
                beforeEach {
                    center = .init()
                    subject.center = center
                    subject.awakeFromNib()
                }
                it("should start waiting for app to finish lauching") {
                    expect(center.debugDescription).to(contain(name.rawValue))
                }
                context("finished launching") {
                    var note: Notification!
                    beforeEach {
                        note = .init(name: name)
                    }
                    it("should move") {
                        waitUntil { done in
                            subject.move = done
                            center.post(note)
                        }
                    }
                }
            }
        }
    }
}
