import Nimble
import Quick
import Testable

class ConnectionMonitorSpec: QuickSpec {
    override func spec() {
        describe(ConnectionMonitor.self) {
            var subject: ConnectionMonitor!
            context(ConnectionMonitor.start(updating:)) {
                context("connected") {
                    beforeEach {
                        subject = .init(url: testBundleUrl("health-check-success.json"))
                    }
                    it("should complete with true") {
                        waitUntil(timeout: 5.0) { done in
                            subject.start { connected in
                                expect(connected) == true
                                done()
                            }
                        }
                    }
                }
                context("error") {
                    beforeEach {
                        subject = .init(url: temp(path: "not-found.json"))
                    }
                    it("should complete with false") {
                        waitUntil { done in
                            subject.start { connected in
                                expect(connected) == false
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
