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
                it("should tell installer to uninstall") {
                    subject.cancelInstallation(.init())
                    expect(mockInstaller.didCall) == "uninstall()"
                }
            }
            context("state changes") {
                var mockNotifier: MockStateNotifier!
                beforeEach {
                    mockNotifier = .createAndInject()
                    subject.viewDidLoad()
                }
                context("not progress") {
                    it("should be ignored") {
                        mockNotifier.send(state: .complete)
                        mockNotifier.send(state: .login)
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
                            mockNotifier.send(state: .busy(value: progress))
                        }
                        it("should hide cancel button") {
                            expect(cancelButton.isHidden) == true
                        }
                    }
                    context("inderterminate") {
                        beforeEach {
                            mockNotifier.send(state: .busy(value: progress))
                        }
                        it("should animate") {
                            expect(progressIndicator.isAnimating) == true
                            expect(progressIndicator.isIndeterminate) == true
                        }
                    }
                    context("determinate") {
                        let expectedProgress = 0.333_3

                        func localized(progress: Double) -> String {
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .percent

                            return formatter.string(from: NSNumber(value: progress))!
                        }
                        beforeEach {
                            progress.totalUnitCount = 3
                            progress.completedUnitCount = 1
                            mockNotifier.send(state: .busy(value: progress))
                        }
                        it("should set fraction completed") {
                            let localizedCompleted = localized(progress: expectedProgress) + " completed"

                            expect(progressIndicator.doubleValue).to(beCloseTo(expectedProgress))
                            expect(progressLabel.stringValue) == localizedCompleted
                        }
                    }
                }
            }
        }
    }
}
