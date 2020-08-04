import Nimble
import Quick
import Testable

class StateCapsuleSpec: QuickSpec {
    override func spec() {
        describe(StateCapsule.self) {
            context(StateCapsule.init) {
                var defaults: UserDefaults!
                beforeEach {
                    defaults = .init()
                    defaults.set(true, forKey: "complete")
                    TestDependency.register(Inject(defaults!))
                }
                it("should load initial state") {
                    expect(StateCapsule().state) == .complete
                }
            }
        }
    }
}
