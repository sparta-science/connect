import Nimble
import Quick
import Testable

class StateSpec: QuickSpec {
    override func spec() {
        describe(State.self) {
            context(State.progress) {
                context(State.login) {
                    it("should be nil") {
                        expect(State.login.progress()).to(beNil())
                    }
                }
                context(State.busy(value:)) {
                    var progress: Progress!
                    beforeEach {
                        progress = .init()
                    }
                    it("should be given") {
                        expect(State.busy(value: progress).progress()) === progress
                    }
                }
            }
        }
    }
}
