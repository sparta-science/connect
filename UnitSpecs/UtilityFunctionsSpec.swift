import Nimble
import Quick
import Testable

class UtilityFunctionsSpec: QuickSpec {
    override func spec() {
        describe(isDebugBuild) {
            it("should be true") {
                expect(isDebugBuild()) == true
            }
        }
        describe(isReleaseBuild) {
            it("should be false") {
                expect(isReleaseBuild()) == false
            }
        }
    }
}
