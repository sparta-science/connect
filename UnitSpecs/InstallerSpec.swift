import Combine
import Nimble
import Quick
import Testable

class InstallerSpec: QuickSpec {
    override func spec() {
        describe(Installer.self) {
            var subject: Installer!
            beforeEach {
                subject = .init()
            }
            context(Installation.self) {
                context(\Installer.statePublisher) {
                    it("should publish state") {
                        var cancellable: AnyCancellable?
                        waitUntil { done in
                            cancellable = subject.statePublisher.sink { changed in
                                if changed == .complete {
                                    done()
                                }
                            }
                            subject.state = .complete
                        }
                        cancellable!.cancel()
                    }
                }
            }
            context(Installer.beginInstallation) {
                it("should not fail") {
                    expect { subject.beginInstallation(login: .init()) }.notTo(throwError())
                }
            }
        }
    }
}
