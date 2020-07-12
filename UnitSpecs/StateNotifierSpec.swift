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
                var publisher: CurrentValueSubject<State, Never>!
                beforeEach {
                    publisher = .init(.login)
                    TestDependency.register(Inject(publisher.eraseToAnyPublisher()))
                }

                it("should receive state on main thread") {
                    DispatchQueue.global(qos: .background).async {
                        publisher.send(.complete)
                    }
                    subject.start { state in
                        expect(Thread.isMainThread) == true
                        expect(state) == .complete
                    }
                }
            }
        }
    }
}
