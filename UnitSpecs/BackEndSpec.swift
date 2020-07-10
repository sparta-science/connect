import Nimble
import Quick
import Testable

class BackEndSpec: QuickSpec {
    override func spec() {
        describe(BackEnd.self) {
            context(BackEnd.appSetupUrlString(bundle:)) {
                context(BackEnd.production) {
                    it("should be home") {
                        expect(BackEnd.production
                            .appSetupUrlString(bundle: testBundle))
                            == "https://home.spartascience.com/api/app-setup"
                    }
                }
            }
        }
    }
}
