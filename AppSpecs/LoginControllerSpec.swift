import Nimble
import Quick
import SpartaConnect

class MockNetworkService: NetworkServiceProtocol {
    var didLogin: String?
    var isSuccess: String?
    func login(username: String) -> String {
        didLogin = username
        return isSuccess!
    }
}

class MockAlertService: AlertProtocol {
    var didShow: NSAlert?
    func show(alert: NSAlert) {
        didShow = alert
    }
}

class LoginControllerSpec: QuickSpec {
    override func spec() {
        describe("LoginController") {
            var subject: LoginController!
            beforeEach {
                subject = .init()
            }
            context("connectAction") {
                class MockWindow: NSWindow {
                    var didClose = false
                    override func close() {
                        didClose = true
                    }
                }
                var window: MockWindow!
                beforeEach {
                    window = .init()
                }
                var mockNetwork: MockNetworkService!
                beforeEach {
                    mockNetwork = .init()
                    subject.networkService = mockNetwork
                }
                context("success") {
                    beforeEach {
                        mockNetwork.isSuccess = "success"
                    }
                    it("should close the window") {
                        let button = NSButton()
                        window.contentView = button
                        subject.connectAction(button)
                        expect(window.didClose) == true
                    }
                    
                    it("should call network with username and password") {
                        subject.connectAction(.init())
                        expect(mockNetwork.didLogin) == "sparta@example.com"
                    }
                }
                
                context("failure") {
                    var mockAlertService: MockAlertService!
                    beforeEach {
                        mockNetwork.isSuccess = "failure"
                        mockAlertService = .init()
                        subject.alertService = mockAlertService
                    }
                    it("should show an error when the login fails") {
                        let button = NSButton()
                        window.contentView = button

                        subject.connectAction(button)
                        expect(window.didClose) == false
                        expect(mockAlertService.didShow).notTo(beNil())
                    }
                }
            }
        }
    }
}
