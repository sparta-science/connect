import Nimble
import Quick
import Testable

class LoginRequestSpec: QuickSpec {
    override func spec() {
        describe(loginRequest(_:)) {
            var login: Login!
            var subject: URLRequest!
            beforeEach {
                login = Init(.init()) {
                    $0!.username = "Malfeasance"
                    $0!.password = "Confluence"
                    $0!.environment = "localhost"
                }
                subject = loginRequest(login)
            }
            it("should create post with params") {
                expect(subject.httpMethod) == "POST"
                expect(subject.url?.absoluteString) ==
                    "http://localhost:4000/api/app-setup"
                    + "?email=Malfeasance"
                    + "&password=Confluence"
                    + "&client-id=delete-me-please-test"
            }
        }
    }
}
