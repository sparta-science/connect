import Nimble
import Quick
import Testable

class ErrorReporterSpec: QuickSpec {
    func getErrorText(panel: NSPanel) -> String {
        (panel.contentView!.subviews[1] as! NSTextField).stringValue
    }
    override func spec() {
        describe(ErrorReporter.self) {
            var subject: ErrorReporter!
            beforeEach {
                subject = .init()
            }
            context(ErrorReporter.report(error:)) {
                it("should show alert") {
                    let error = MockError()
                    DispatchQueue.main.async {
                        let panel = NSApp.modalWindow! as! NSPanel
                        expect(self.getErrorText(panel: panel)) == "mock error"
                        NSApp.stopModal()
                    }
                    subject.report(error: error)
                }
            }
        }
    }
}
