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
                it("should list all backends including simulated") {
                    expect(subject.availableServers) == [
                        "Sparta Offline System",
                        "home.spartascience.com",
                        "localhost",
                        "staging",
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
                context("environment") {
                    var defaults: UserDefaults!
                    beforeEach {
                        defaults = .createAndInject()
                    }
                    context("online") {
                        it("should return a LoginRequest with a base url") {
                            expect(subject.loginRequest(login)) == Init(LoginRequest()) {
                                $0.username = "mike"
                                $0.password = "secret"
                                $0.baseUrlString = "https://home.spartascience.com/api/app-setup"
                            }
                        }
                    }
                    context("offline") {
                        beforeEach {
                            defaults.set(true, forKey: "offline installation")
                        }
                        it("should return a LoginRequest with a base url") {
                            expect(subject.loginRequest(login)) == Init(LoginRequest()) {
                                $0.username = "mike"
                                $0.password = "secret"
                                $0.baseUrlString = "http://spartascan.local/api/app-setup"
                            }
                        }
                    }
                }
                context("staging") {
                    beforeEach {
                        login.environment = "staging"
                    }
                    it("should go to staging.spartascience.com") {
                        expect(subject.loginRequest(login).baseUrlString) == "https://staging.spartascience.com/api/app-setup"
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
