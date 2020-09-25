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
                    it("should update name and display it with black text") {
                        mockDetector.detection!("my forceplate")
                        expect(subject.forcePlateName.stringValue) == "my forceplate"
                        expect(subject.forcePlateName.textColor) == .labelColor
                    }
                    context("no force plate") {
                        it("should say unplugged with red text") {
                            mockDetector.detection!(nil)
                            expect(subject.forcePlateName.stringValue) == "unplugged"
                            expect(subject.forcePlateName.textColor) == .systemRed
                        }
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
                    it("should update status") {
                        expect(subject.connectionStatus.stringValue) == "🟢 online"
                        mock.check!(false)
                        expect(subject.connectionStatus.stringValue) == "🔴 offline"
                    }
                    context("when time fires") {
                        beforeEach {
                            mock.check = nil
                        }
                        it("should check status") {
                            expect(mock.check).notTo(beNil())
                        }
                    }
                }
            }
            describe(ConnectedController.viewDidDisappear) {
                var mock: MockHealthCheck!
                beforeEach {
                    mock = .createAndInject()
                }
                it("should cancel health check") {
                    subject.viewDidDisappear()
                    expect(mock.didCall) == "cancel()"
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
