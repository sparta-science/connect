import Nimble
import Quick
import Testable

class BackEndSpec: QuickSpec {
    override func spec() {
        describe(BackEnd.self) {
            context(BackEnd.appSetupUrl) {
                context(BackEnd.production) {
                    it("should be home") {
                        expect(BackEnd.production.appSetupUrl(bundle: testBundle).absoluteString)
                            == "https://home.spartascience.com/api/app-setup"
                    }
                }
            }
        }
    }
}
