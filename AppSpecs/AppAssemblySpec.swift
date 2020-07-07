import Nimble
import Quick
import SpartaConnect
import Testable

class AppAssemblySpec: QuickSpec {
    override func spec() {
        describe(AppAssembly.self) {
            let appSupportUrlName = "installation url"
            context(appSupportUrlName) {
                it("should have path that ends with library app support bundle id") {
                    var url = Inject<URL>(appSupportUrlName)
                    expect(url.wrappedValue.path).to(endWith("/Library/Application Support/com.spartascience.SpartaConnect"))
                }
            }
        }
    }
}
