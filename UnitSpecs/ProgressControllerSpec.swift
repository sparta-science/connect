import Combine
import Nimble
import Quick
import Testable

class MockIndicator: NSProgressIndicator {
    var isAnimating = false
    override func startAnimation(_ sender: Any?) {
        isAnimating = true
    }
}

class ProgressControllerSpec: QuickSpec {
    override func spec() {
        describe(ProgressController.self) {
            var subject: ProgressController!
            beforeEach {
                subject = .init()
            }
            context(ProgressController.cancelInstallation(_:)) {
                var mockInstaller: MockInstaller!
                beforeEach {
                    mockInstaller = .createAndInject()
                }
                it("should tell installer to cancel installation") {
                    subject.cancelInstallation(.init())
                    expect(mockInstaller.didCall) == "cancelInstallation()"
                }
            }
            context("state changes") {
                var publisher: CurrentValueSubject<State, Never>!
                beforeEach {
                    publisher = .init(.login)
                    TestDependency.register(Inject(publisher.eraseToAnyPublisher()))
                    subject.viewDidLoad()
                }
                context("not progress") {
                    it("should be ignored") {
                        publisher.send(.complete)
                        publisher.send(.login)
                    }
                }
                context("progress") {
                    var cancelButton: NSButton!
                    var progressIndicator: MockIndicator!
                    var progressLabel: NSTextField!
                    var progress: Progress!
                    beforeEach {
                        progress = .init()
                        cancelButton = NSButton()
                        progressIndicator = MockIndicator()
                        progressLabel = NSTextField()
                        subject.cancelButton = cancelButton
                        subject.progressIndicator = progressIndicator
                        subject.progressLabel = progressLabel
                    }
                    context("not cancellable") {
                        beforeEach {
                            progress.isCancellable = false
                            publisher.send(.busy(value: progress))
                        }
                        it("should hide cancel button") {
                            expect(cancelButton.isHidden).toEventually(beTrue())
                        }
                    }
                    context("inderterminate") {
                        beforeEach {
                            publisher.send(.busy(value: progress))
                        }
                        it("should animate") {
                            expect(progressIndicator.isAnimating).toEventually(beTrue())
                            expect(progressIndicator.isIndeterminate) == true
                        }
                    }
                    context("determinate") {
                        beforeEach {
                            progress.totalUnitCount = 3
                            progress.completedUnitCount = 1
                            publisher.send(.busy(value: progress))
                        }
                        it("should set fraction completed") {
                            expect(progressIndicator.doubleValue).toEventually(beCloseTo(0.333_3))
                            expect(progressLabel.stringValue) == "33% completed"
                        }
                    }
                }
            }
        }
    }
}
