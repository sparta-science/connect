import Nimble
import Quick
import Testable

class DebugServerLocatorSpec: QuickSpec {
    override func spec() {
        describe(DebugServerLocator.self) {
            var subject: DebugServerLocator!
            beforeEach {
                subject = .init()
            }
            context(\DebugServerLocator.availableServers) {
                it("should list all backends") {
                    expect(subject.availableServers) == [
                        "localhost",
                        "staging",
                        "production",
                        "simulate install failure",
                        "simulate SF State Gators",
                        "simulate UC Santa Cruz"
                    ]
                }
            }
            context(DebugServerLocator.loginRequest(_:)) {
                var login: Login!
                beforeEach {
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
                context("simulated") {
                    beforeEach {
                        login.environment = "simulate SF State Gators"
                        TestDependency.register(Inject(testBundle))
                    }
                    it("should be json path") {
                        expect(subject.loginRequest(login).baseUrlString)
                            == testBundleUrl("successful-response-sf-state-gators.json").absoluteString
                    }
                }
            }
        }
    }
}
