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
