import Combine
import Nimble
import Quick
@testable import Testable

class StateCapsuleSpec: QuickSpec {
    override func spec() {
        describe(StateCapsule.self) {
            var defaults: UserDefaults!
            var subject: StateCapsule!
            beforeEach {
                defaults = .createAndInject()
                defaults.removeObject(forKey: "complete")
                subject = .init()
            }
            context(StateCapsule.init) {
                beforeEach {
                    defaults.set(true, forKey: "complete")
                }
                it("should load initial state") {
                    expect(StateCapsule().state) == .complete
                }
            }
            context(StateCapsule.publisher) {
                it("should be state publisher") {
                    expect(subject.publisher()).to(beAKindOf(AnyPublisher<State, Never>.self))
                }
                it("should publish state changes") {
                    waitUntil { done in
                        _ = subject.publisher().sink {
                            expect($0) == .login
                            done()
                        }
                    }
                }
            }

            context(StateCapsule.startReceiving) {
                it("should start file receive progress") {
                    subject.startReceiving()
                    let progress = subject.state.progress()
                    expect(progress?.isCancellable) == true
                    expect(progress?.kind) == .file
                    expect(progress?.fileOperationKind) == .receiving
                }
            }
            context(StateCapsule.reset) {
                it("should reset state to login and save false to defaults") {
                    defaults.set(true, forKey: "complete")
                    waitUntil { done in
                        subject.reset(after: done)
                        expect(subject.state.progress()).notTo(beNil())
                    }
                    expect(subject.state) == .login
                    expect(defaults.bool(forKey: "complete")) == false
                }
            }
            context(StateCapsule.complete) {
                it("should set state to complete and save true to defaults") {
                    subject.complete()
                    expect(subject.state) == .complete
                    expect(defaults.bool(forKey: "complete")) == true
                }
            }
            context(StateCapsule.update(progress:)) {
                context("busy") {
                    beforeEach {
                        subject.state = .busy(value: .init())
                    }
                    it("should set state to busy with new progress") {
                        let progress = Progress(totalUnitCount: 2_020, parent: .init(), pendingUnitCount: 10)
                        subject.update(progress: progress)
                        expect(subject.state.progress()) == progress
                    }
                }
                context("complete") {
                    beforeEach {
                        subject.state = .complete
                    }
                    it("should not change to busy") {
                        subject.update(progress: .init())
                        expect(subject.state) == .complete
                    }
                }
            }
        }
    }
}
