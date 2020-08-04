import Nimble
import Quick
import Testable

class StateTrackerSpec: QuickSpec {
    override func spec() {
        describe(StateTracker.self) {
            context(StateTracker.loadState) {
                var subject: StateTracker!
                beforeEach {
                    subject = .init()
                }
                afterEach {
                    UserDefaults.standard.removeObject(forKey: "complete")
                }
                it("should return saved state") {
                    UserDefaults.standard.set(true, forKey: "complete")
                    expect(subject.loadState()) == .complete
                }
                it("should return .login by default") {
                    expect(subject.loadState()) == .login
                }
            }
        }
    }
}
