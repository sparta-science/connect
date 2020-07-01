import Nimble
import Quick
import SpartaConnect
import Swinject

class PlaceholdersSpec: QuickSpec {
    override func spec() {
        describe(Container.self) {
            context("register") {
                it("should be not nil") {
                    let entry = Container().register(name: "some") { _ in "value" }
                    expect(entry).notTo(beNil())
                }
            }
        }
    }
}
