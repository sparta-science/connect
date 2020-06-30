import Nimble
import Quick
import Testable

class BackEndSpec: QuickSpec {
    override func spec() {
        describe(BackEnd.self) {
            context(BackEnd.baseUrl) {
                context(BackEnd.production) {
                    it("should be home") {
                        expect(BackEnd.production.baseUrl().absoluteString)
                            == "https://home.spartascience.com"
                    }
                }
            }
        }
    }
}
