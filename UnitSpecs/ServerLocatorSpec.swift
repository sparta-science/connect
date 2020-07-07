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
                    expect(subject.availableServers) == ["localhost", "fake server", "staging", "production"]
                }
            }
            context(ServerLocator.baseUrlString(_:)) {
                beforeEach {
                    TestDependency.register(Inject(testBundle))
                }
                it("should return home.spartascience.com") {
                    expect(subject.baseUrlString("production")) == "https://home.spartascience.com/api/app-setup"
                }
            }
            context(ServerLocator.loginRequest(_:)) {
                var login: Login!
                beforeEach {
                    TestDependency.register(Inject(testBundle))
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