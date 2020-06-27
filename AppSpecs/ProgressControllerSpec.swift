import Nimble
import Quick
import SpartaConnect
import Combine

class MockInstaller: Installation {
    var statePublisher: AnyPublisher<State, Never>
    
    var state: State
    
    func beginInstallation(login: Login) {
        
    }
    
    func cancelInstallation() {
        
    }
    
    func uninstall() {
    }
    var mockPublisher: CurrentValueSubject<State, Never>
    
    init() {
        state = .login
        mockPublisher = CurrentValueSubject(state)
        statePublisher = mockPublisher.eraseToAnyPublisher()
    }
}

class MockIndicator: NSProgressIndicator {
    var isAnimating = false
    override func startAnimation(_ sender: Any?) {
        isAnimating = true
    }
}

class ProgressControllerSpec: QuickSpec {
    override func spec() {
        describe("ProgressController") {
            var subject: ProgressController!
            beforeEach {
                subject = .init()
            }
            context("state changes") {
                var mockInstaller: MockInstaller!
                beforeEach {
                    mockInstaller = .init()
                    subject.installer = mockInstaller
                    subject.viewDidLoad()
                }
                context("not progress") {
                    it("should be ignored") {
                        mockInstaller.mockPublisher.send(.complete)
                        mockInstaller.mockPublisher.send(.login)
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
                            mockInstaller.mockPublisher.send(.busy(value: progress))
                        }
                        it("should hide cancel button") {
                            expect(cancelButton.isHidden).toEventually(beTrue())
                        }
                    }
                    context("inderterminate") {
                        beforeEach {
                            mockInstaller.mockPublisher.send(.busy(value: progress))
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
                            mockInstaller.mockPublisher.send(.busy(value: progress))
                        }
                        it("should set fraction completed") {
                            expect(progressIndicator.doubleValue).toEventually(beCloseTo(0.3333))
                            expect(progressLabel.stringValue) == "33% completed"
                        }
                    }
                }
            }
        }
    }
}
