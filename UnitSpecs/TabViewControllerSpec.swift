import Combine
import Nimble
import Quick
import Testable

extension TabViewController {
    func add(numberOfTabs: Int) {
        (1...numberOfTabs).forEach { _ in
            addChild(Init(.init()) { $0.view = .init() })
        }
    }
}

class TabViewControllerSpec: QuickSpec {
    override func spec() {
        describe(TabViewController.self) {
            var subject: TabViewController!
            beforeEach {
                subject = Init(.init()) {
                    $0?.add(numberOfTabs: 4)
                }
            }
            context("state changes") {
                var mockNotifier: MockStateNotifier!
                beforeEach {
                    mockNotifier = .createAndInject()
                    expect(subject.view).notTo(beNil())
                    subject.selectedTabViewItemIndex = 3
                }
                it("should update to corresponding tab") {
                    let tabForState: [Int: State] = [
                        0: .login,
                        1: .busy(value: .init()),
                        2: .complete
                    ]
                    tabForState.forEach { (tab: Int, state: State) in
                        mockNotifier.send(state: state)
                        expect(subject.selectedTabViewItemIndex) == tab
                    }
                }
            }
        }
    }
}
