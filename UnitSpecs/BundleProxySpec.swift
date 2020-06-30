import Nimble
import Quick
import Testable

class BundleProxySpec: QuickSpec {
    override func spec() {
        describe(BundleProxy.self) {
            var subject: BundleProxy!
            beforeEach {
                TestDependency.register(Inject(testBundle))
                subject = .init()
            }
            context(BundleProxy.awakeAfter(using:)) {
                it("should be main bundle") {
                    expect(subject.awakeAfter(using: uninitialized())) === testBundle
                }
            }
        }
    }
}
