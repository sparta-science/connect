import Combine
import Nimble
import Quick
import Testable

class ConnectionMonitorSpec: QuickSpec {
    override func spec() {
        describe(ConnectionMonitor.self) {
            var subject: ConnectionMonitor!
            var cancel: Cancellable!
            afterEach {
                cancel.cancel()
            }
            context(ConnectionMonitor.checkHealth(every:)) {
                context("connected") {
                    beforeEach {
                        subject = .init(url: testBundleUrl("health-check-success.json"))
                    }
                    it("should publish true immediately") {
                        waitUntil(timeout: .seconds(5)) { done in
                            cancel = subject.checkHealth(every: 1_000).sink { connected in
                                expect(connected) == true
                                done()
                            }
                        }
                    }
                    it("should publish again after time interval") {
                        var times = 0
                        waitUntil(timeout: .seconds(5)) { done in
                            cancel = subject.checkHealth(every: 0).sink { _ in
                                times += 1
                                if times == 2 {
                                    done()
                                }
                            }
                        }
                    }
                }
                context("error") {
                    beforeEach {
                        subject = .init(url: temp(path: "not-found.json"))
                    }
                    it("should not complete") {
                        cancel = subject.checkHealth(every: 10).sink(receiveCompletion: { _ in
                            fail("should not complete")
                        }, receiveValue: { _ in
                            fail("should not receive")
                        })
                        RunLoop.run(for: 0.01)
                    }
                }
            }
        }
    }
}
