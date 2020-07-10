import Nimble
import Quick
import Testable

class ApiServerSpec: QuickSpec {
    override func spec() {
        describe(ApiServer.self) {
            context(ApiServer.serverUrlString) {
                context(ApiServer.production) {
                    it("should be home") {
                        expect(ApiServer.production.serverUrlString())
                            == "https://home.spartascience.com/api/app-setup"
                    }
                }
            }
        }
    }
}
