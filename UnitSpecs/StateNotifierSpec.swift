import Combine
import Nimble
import Quick
import Testable

class StateNotifierSpec: QuickSpec {
    override func spec() {
        describe(StateNotifier.self) {
            var subject: StateNotifier!
            beforeEach {
                subject = .init()
            }
            describe(StateNotifier.start(receiver:)) {
                var publisher: PassthroughSubject<State, Never>!
                beforeEach {
                    publisher = .init()
                    TestDependency.register(Inject(publisher.eraseToAnyPublisher()))
                }

                it("should receive state on main thread") {
                    waitUntil { done in
                        subject.start { state in
                            expect(Thread.isMainThread) == true
                            expect(state) == .complete
                            done()
                        }
                        DispatchQueue.global(qos: .background).async {
                            publisher.send(.complete)
                        }
                    }
                }
            }
        }
    }
}
