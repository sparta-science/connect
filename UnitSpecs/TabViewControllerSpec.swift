import Combine
import Nimble
import Quick
import Testable

class TabViewControllerSpec: QuickSpec {
    override func spec() {
        describe(TabViewController.self) {
            var subject: TabViewController!
            beforeEach {
                subject = Init(.init()) { controller in
                    (0...2).forEach { _ in
                        controller.addChild(Init(.init()) { $0.view = .init() })
                    }
                }
            }
            context("login state") {
                var mockNotifier: MockStateNotifier!
                beforeEach {
                    mockNotifier = .createAndInject()
                    expect(subject.view).notTo(beNil())
                }
                it("should select tab 0") {
                    expect(subject.selectedTabViewItemIndex) == 0
                }
                context("changed to busy") {
                    beforeEach {
                        mockNotifier.send(state: .busy(value: .init()))
                    }
                    it("selects tab 1") {
                        expect(subject.selectedTabViewItemIndex) == 1
                    }
                }
                context("changed to complete") {
                    beforeEach {
                        mockNotifier.receiver!(.complete)
                    }
                    it("selects tab 2") {
                        expect(subject.selectedTabViewItemIndex) == 2
                    }
                }
            }
        }
    }
}
