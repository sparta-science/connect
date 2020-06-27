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
                    it("should update UI") {
                        let progress = Progress()
                        mockInstaller.mockPublisher.send(.busy(value: progress))
                    }
                }
            }
        }
    }
}
