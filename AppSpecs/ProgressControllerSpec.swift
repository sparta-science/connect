import Nimble
import Quick
import SpartaConnect

class ProgressControllerSpec: QuickSpec {
    override func spec() {
        describe("ProgressController") {
            var subject: ProgressController!
            beforeEach {
                subject = .init()
            }
            context("state changes") {
                beforeEach {
                    subject.viewDidLoad()
                }
                context("not progress") {
                    it("should be ignored") {
                        Installer.shared.state = .complete
                    }
                }
                context("progress") {
                    it("should update UI") {
                        let progress = Progress()
                        Installer.shared.state = .busy(value: progress)
                    }
                }
            }
        }
    }
}
