import Nimble
import Quick
import Testable

class BackEndSpec: QuickSpec {
    override func spec() {
        describe(BackEnd.self) {
            context(BackEnd.serverUrlString) {
                context(BackEnd.production) {
                    it("should be home") {
                        expect(BackEnd.production.serverUrlString())
                            == "https://home.spartascience.com/api/app-setup"
                    }
                }
            }
        }
    }
}
