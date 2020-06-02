import Nimble
import Quick

class FirstSpec: QuickSpec {
    override func spec() {
        describe("first spec") {
            context("1 + 1") {
                it("should be 2") {
                    expect(1 + 1) == 2
                }
            }
        }
    }
}
