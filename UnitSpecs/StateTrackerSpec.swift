import Nimble
import Quick
import Testable

class StateTrackerSpec: QuickSpec {
    override func spec() {
        describe(StateTracker.self) {
            context(StateTracker.loadState) {
                var subject: StateTracker!
                var defaults: UserDefaults!
                beforeEach {
                    subject = .init()
                    defaults = .init()
                    TestDependency.register(Inject(defaults!))
                }
                afterEach {
                    defaults.removeObject(forKey: "complete")
                }
                it("should return saved state") {
                    defaults.set(true, forKey: "complete")
                    expect(subject.loadState()) == .complete
                }
                it("should return .login by default") {
                    expect(subject.loadState()) == .login
                }
            }
        }
    }
}
