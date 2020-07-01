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
                var publisher: CurrentValueSubject<State, Never>!
                beforeEach {
                    publisher = .init(.login)
                    TestDependency.register(Inject(publisher.eraseToAnyPublisher()))
                    expect(subject.view).notTo(beNil())
                }
                it("should select tab 0") {
                    expect(subject.selectedTabViewItemIndex) == 0
                }
                context("changed to busy") {
                    beforeEach {
                        publisher.send(.busy(value: .init()))
                    }
                    it("selects tab 1") {
                        expect(subject.selectedTabViewItemIndex)
                            .toEventually(equal(1))
                    }
                }
                context("changed to complete") {
                    beforeEach {
                        publisher.send(.complete)
                    }
                    it("selects tab 2") {
                        expect(subject.selectedTabViewItemIndex)
                            .toEventually(equal(2))
                    }
                }
                it("should receive on main thread") {
                    DispatchQueue.global(qos: .background).async {
                        publisher.send(.complete)
                    }
                    expect(subject.selectedTabViewItemIndex)
                        .toEventually(equal(2))
                }
            }
        }
    }
}
