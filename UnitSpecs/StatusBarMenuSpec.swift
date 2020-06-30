import Nimble
import Quick
import Testable

class StatusBarMenuSpec: QuickSpec {
    override func spec() {
        describe(StatusBarMenu.self) {
            var subject: StatusBarMenu!
            var image: NSImage!
            beforeEach {
                TestDependency.inject(MockStatusItem())
                TestDependency.register(Inject(testBundle))
                image = .init(size: .zero)
                subject = Init(.init()) {
                    $0.addItem(Init(.init(title: "first", action: nil, keyEquivalent: "")) {
                        $0.image = image
                    })
                }
            }
            context(StatusBarMenu.awakeFromNib) {
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
                        expect(statusItem.behavior) == [
                            .terminationOnRemoval, .removalAllowed
                        ]
                        expect(statusItem.autosaveName) == testBundle.bundleIdentifier
                    }
                }
            }
        }
    }
}
