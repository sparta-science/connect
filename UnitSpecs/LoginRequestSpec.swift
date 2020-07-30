import Nimble
import Quick
import Testable

class LoginRequestSpec: QuickSpec {
    override func spec() {
        describe(percentEncode(_:)) {
            it("should percent encode + space ! and . and ,") {
                expect(percentEncode("+!. ,@")) == "%2B%21%2E%20%2C%40"
            }
        }

        describe(loginRequest(_:)) {
            var login: LoginRequest!
            var subject: URLRequest!
            beforeEach {
                login = Init(.init()) {
                    $0!.username = "meanwhile+effortless@example.com"
                    $0!.password = "jumping hoops"
                    $0!.baseUrlString = "http://localhost:4000"
                }
                subject = loginRequest(login)
            }
            it("should create post with params") {
                expect(subject.httpMethod) == "POST"
                expect(subject.url?.absoluteString) ==
                    "http://localhost:4000/api/app-setup"
                    + "?client-id=TestOnlyDeleteMePlease"
                    + "&email=meanwhile%2Beffortless%40example%2Ecom"
                    + "&password=jumping%20hoops"
            }
        }
    }
}
