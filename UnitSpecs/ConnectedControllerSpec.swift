import Nimble
import Quick
import Testable

class ConnectedControllerSpec: QuickSpec {
    override func spec() {
        describe(ConnectedController.self) {
            var subject: ConnectedController!
            beforeEach {
                subject = .init()
            }
            describe(ConnectedController.viewDidLoad) {
                var mockDetector: MockDetector!
                beforeEach {
                    mockDetector = .createAndInject()
                }
                it("should setup observer") {
                    subject.viewDidLoad()
                    expect(mockDetector.detection).notTo(beNil())
                }
                context("force plate detection") {
                    var nameLabel: NSTextField!
                    beforeEach {
                        subject.viewDidLoad()
                        nameLabel = .init()
                        subject.forcePlateName = nameLabel
                    }
                    it("should update name") {
                        mockDetector.detection!("my forceplate")
                        expect(subject.forcePlateName.stringValue) == "my forceplate"
                    }
                }
            }
            describe(ConnectedController.viewDidAppear) {
                var mock: MockHealthCheck!
                beforeEach {
                    mock = .createAndInject()
                }
                it("should start checking health") {
                    subject.viewDidAppear()
                    expect(mock.check).notTo(beNil())
                }
                context("observing") {
                    var statusLabel: NSTextField!

                    beforeEach {
                        subject.viewDidAppear()
                        statusLabel = .init()
                        subject.connectionStatus = statusLabel
                        mock.check!(true)
                    }
                    afterEach {
                        subject.timer?.invalidate()
                    }
                    it("should update status") {
                        expect(subject.connectionStatus.stringValue) == "connected"
                        mock.check!(false)
                        expect(subject.connectionStatus.stringValue) == "not connected"
                    }
                    it("should create timer") {
                        expect(subject.timer).notTo(beNil())
                    }
                    context("when time fires") {
                        beforeEach {
                            mock.check = nil
                        }
                        it("should check status") {
                            subject.timer?.fire()
                            expect(mock.check).notTo(beNil())
                        }
                    }
                }
            }
            describe(ConnectedController.viewDidDisappear) {
                beforeEach {
                    subject.timer = .init(timeInterval: 10, repeats: false, block: { _ in })
                }
                it("should invalidate timer") {
                    subject.viewDidDisappear()
                    expect(subject.timer?.isValid) == false
                }
            }
            context(ConnectedController.disconnect(_:)) {
                var mockInstaller: MockInstaller!
                beforeEach {
                    mockInstaller = .createAndInject()
                }
                it("should uninstall") {
                    ConnectedController().disconnect(.init())
                    expect(mockInstaller.didCall) == "uninstall()"
                }
            }
        }
    }
}
