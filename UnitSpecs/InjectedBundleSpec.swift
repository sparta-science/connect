import Nimble
import Quick
import Testable

class InjectedBundleSpec: QuickSpec {
    override func spec() {
        describe(InjectedBundle.self) {
            var subject: InjectedBundle!
            beforeEach {
                TestDependency.register(Inject(testBundle))
                subject = .init()
            }
            context(InjectedBundle.awakeAfter(using:)) {
                it("should be main bundle") {
                    expect(subject.awakeAfter(using: uninitialized())) !== testBundle
                }
            }
        }
    }
}
