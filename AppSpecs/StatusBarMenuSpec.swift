import Quick
import Nimble
import SpartaConnect

class StatusBarMenuSpec: QuickSpec {
    override func spec() {
        describe("StatusBarMenu") {
            var subject: StatusBarMenu!
            var image: NSImage!
            beforeEach {
                subject = .init()
                image = .init(size: .zero)
                let item = subject.addItem(
                    withTitle: "first",
                    action: nil,
                    keyEquivalent: ""
                )
                item.image = image
            }
            context("awakeFromNib") {
                beforeEach {
                    subject.awakeFromNib()
                }
                context("statusItem") {
                    var statusItem: NSStatusItem!
                    beforeEach {
                        statusItem = subject.statusItem
                    }
                    it("configures status item with menu") {
                        expect(statusItem.button?.title) == "first"
                        expect(statusItem.button?.image) === image
                        expect(statusItem.menu) === subject
                    }
                    it("should have expected properties") {
                        expect(statusItem.isVisible) == true
                        expect(statusItem.behavior) == [
                            .terminationOnRemoval, .removalAllowed
                        ]
                        expect(statusItem.autosaveName) == Bundle.main.bundleIdentifier
                        expect(statusItem.length) == NSStatusItem.squareLength
                    }
                }
            }
        }
    }
}
