import Nimble
import Quick
import Testable

class HealthCheckSpec: QuickSpec {
    override func spec() {
        describe(HealthCheck.self) {
            var subject: HealthCheck!
            beforeEach {
                subject = Injected.instance
            }
            context("update") {
                it("should complete") {
                    waitUntil { done in
                        subject.update { _ in
                            done()
                        }
                    }
                }
            }
        }
    }
}
