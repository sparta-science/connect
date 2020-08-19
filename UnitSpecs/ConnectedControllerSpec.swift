import Nimble
import Quick
import Testable

class ConnectedControllerSpec: QuickSpec {
    override func spec() {
        describe(ConnectedController.self) {
            describe(ConnectedController.viewDidLoad) {
                var subject: ConnectedController!
                var mockDetector: MockDetector!
                beforeEach {
                    subject = .init()
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
                    context("connected") {
                        it("should update name") {
                            mockDetector.detection!("my forceplate")
                            expect(subject.forcePlateName.stringValue) == "my forceplate"
                        }
                    }
                    context("disconnected") {
                        it("should update change to unplugged") {
                            mockDetector.detection!(nil)
                            expect(subject.forcePlateName.stringValue) == "unplugged"
                        }
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
