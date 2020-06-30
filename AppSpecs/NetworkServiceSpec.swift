import Quick
import Nimble
import SpartaConnect

class NetworkServiceSpec: QuickSpec {
    override func spec() {
        describe(NetworkService.self) {
            var subject: NetworkService!
            beforeEach {
                subject = .init()
            }
            context(NetworkService.login) {
                it("should be success") {
                    expect(subject.login(username: "anything")) == "success"
                }
            }
        }
    }
}
