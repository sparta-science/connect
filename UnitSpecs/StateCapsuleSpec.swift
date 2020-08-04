import Nimble
import Quick
import Testable

class StateCapsuleSpec: QuickSpec {
    override func spec() {
        describe(StateCapsule.self) {
            var defaults: UserDefaults!
            var subject: StateCapsule!
            beforeEach {
                defaults = .init()
                TestDependency.register(Inject(defaults!))
                subject = .init()
            }
            context(StateCapsule.init) {
                beforeEach {
                    defaults.set(true, forKey: "complete")
                }
                it("should load initial state") {
                    expect(StateCapsule().state) == .complete
                }
            }

            context(StateCapsule.startReceiving) {
                it("should start state progress") {
                    subject.startReceiving()
                    expect(subject.state.progress()).notTo(beNil())
                }
            }
            context(StateCapsule.reset) {
                it("should reset state to login") {
                    subject.reset()
                    expect(subject.state) == .login
                }
            }
            context(StateCapsule.complete) {
                it("should set state to complete") {
                    subject.complete()
                    expect(subject.state) == .complete
                }
            }
        }
    }
}
