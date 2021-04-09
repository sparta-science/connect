import Nimble
import Quick
import Testable

class ApiServerSpec: QuickSpec {
    override func spec() {
        describe(ApiServer.self) {
            var defaults: UserDefaults!
            context(ApiServer.serverUrlString) {
                beforeEach {
                    defaults = .createAndInject()
                }
                context(ApiServer.production) {
                    context("default") {
                        it("should be home") {
                            expect(ApiServer.production.serverUrlString())
                                == "https://home.spartascience.com/api/app-setup"
                        }
                    }
                    context("defined") {
                        beforeEach {
                            defaults.set("https://custom.host", forKey: "custom app url")
                        }
                        afterEach {
                            defaults.removeObject(forKey: "custom app url")
                        }
                        it("should be custom") {
                            expect(ApiServer.production.serverUrlString())
                                == "https://custom.host"
                        }
                    }
                }
            }
        }
    }
}
