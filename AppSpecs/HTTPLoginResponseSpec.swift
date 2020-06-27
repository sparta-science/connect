import Nimble
import Quick
import SpartaConnect

class HTTPLoginResponseSpec: QuickSpec {
    override func spec() {
        describe("HTTPLoginServerResponse") {
            context("decode") {
                
                func decode(string: String) -> HTTPLoginResponse {
                    try! JSONDecoder().decode(HTTPLoginResponse.self,
                                              from: string.data(using: .ascii)!)
                }
                
                context("success") {
                    it("should de decoded") {
                        let string = #"{"message":{"downloadUrl":"https://localhost/vernal_falls.tar","vernalFallsVersion":"1.4896"},"org":{"id":38,"name":"Training Ground"},"user":{"email":"sparta@example.com","id":4728,"name":"Test Sparta User"},"vernalFallsConfig":{"key":"value"}}"#
                        if case .success(let success) = decode(string: string) {
                            expect(success.message).notTo(beNil())
                        } else {
                            fail("should be success")
                        }
                    }
                }
                context("failure") {
                    it("should de decoded") {
                        let string = #"{"error":"server error"}"#
                        if case .failure(let failure) = decode(string: string) {
                            expect(failure.error) == "server error"
                        } else {
                            fail("should be success")
                        }
                    }
                }
            }
        }
    }
}
