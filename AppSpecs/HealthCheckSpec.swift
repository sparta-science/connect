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
                xit("TODO: pz never completes") {
                    waitUntil { done in
                        subject.start { _ in
                            done()
                        }
                    }
                }
            }
        }
    }
}
