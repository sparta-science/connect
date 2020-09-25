import Nimble
import Quick
import Testable

extension LoginRequest {
    override public func isEqual(_ object: Any?) -> Bool {
        guard let otherRequest = object as? LoginRequest else {
            return false
        }
        return otherRequest.username == username
            && otherRequest.password == password
        && otherRequest.baseUrlString == baseUrlString
    }
}

class ServerLocatorSpec: QuickSpec {
    override func spec() {
        describe(ServerLocator.self) {
            var subject: ServerLocator!
            beforeEach {
                subject = .init()
            }
            context(\ServerLocator.availableServers) {
                it("should list all backends") {
                    expect(subject.availableServers) == [
                        "Sparta Offline System",
                        "home.spartascience.com"
                    ]
                }
            }
            context(ServerLocator.loginRequest(_:)) {
                var login: Login!
                var defaults: UserDefaults!
                beforeEach {
                    defaults = .createAndInject()
                    defaults.set(false, forKey: "offline installation")
                    login = Init(.init()) {
                        $0!.username = "mike"
                        $0!.password = "secret"
                    }
                }
                it("should return a LoginRequest with a base url") {
                    expect(subject.loginRequest(login)) == Init(LoginRequest()) {
                        $0.username = "mike"
                        $0.password = "secret"
                        $0.baseUrlString = "https://home.spartascience.com/api/app-setup"
                    }
                }
            }
        }
    }
}
