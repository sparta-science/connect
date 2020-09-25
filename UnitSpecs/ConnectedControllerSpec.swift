import Combine
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
            context("health check") {
                var mock: MockHealthCheck!
                var statusLabel: NSTextField!
                beforeEach {
                    mock = .createAndInject()
                    statusLabel = .init()
                    subject.connectionStatus = statusLabel
                }
                describe(ConnectedController.viewDidAppear) {
                    context("error") {
                        beforeEach {
                            mock.publisher = Empty().eraseToAnyPublisher()
                            subject.viewDidAppear()
                        }
                        it("should check every second and show connecting...") {
                            expect(mock.interval) == 1.0
                            expect(subject.connectionStatus.stringValue) == "connecting..."
                        }
                    }
                    context("success") {
                        context("connected") {
                            beforeEach {
                                mock.publisher = Just(true).eraseToAnyPublisher()
                                subject.viewDidAppear()
                            }
                            it("should show online") {
                                expect(subject.connectionStatus.stringValue) == "🟢 online"
                            }
                        }
                        context("disconnected") {
                            beforeEach {
                                mock.publisher = Just(false).eraseToAnyPublisher()
                                subject.viewDidAppear()
                            }
                            it("should show offline") {
                                expect(subject.connectionStatus.stringValue) == "🔴 offline"
                            }
                        }
                    }
                }
                describe(ConnectedController.viewDidDisappear) {
                    var wasCancelled = false
                    beforeEach {
                        mock.publisher = Empty(completeImmediately: false)
                        .handleEvents(receiveCancel: {
                            wasCancelled = true
                        }).eraseToAnyPublisher()
                        subject.viewDidAppear()
                        expect(wasCancelled) == false
                    }
                    it("should cancel health check") {
                        subject.viewDidDisappear()
                        expect(wasCancelled) == true
                    }
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
