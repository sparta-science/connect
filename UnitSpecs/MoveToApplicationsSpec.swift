import Nimble
import Quick
import Testable

class MoveToApplicationsSpec: QuickSpec {
    override func spec() {
        describe(MoveToApplications.self) {
            var subject: MoveToApplications!
            beforeEach {
                subject = .init()
            }
            context(MoveToApplications.awakeFromNib) {
                var center: NotificationCenter!
                let didFinish = NSApplication.didFinishLaunchingNotification
                beforeEach {
                    center = .init()
                    TestDependency.register(Inject(center!))
                    subject.awakeFromNib()
                }
                it("should start waiting for app to finish lauching") {
                    expect(center.debugDescription).to(contain(didFinish.rawValue))
                }
                context("finished launching") {
                    var note: Notification!
                    beforeEach {
                        note = .init(name: didFinish)
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
