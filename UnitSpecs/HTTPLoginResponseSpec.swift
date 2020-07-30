import Nimble
import Quick
import Testable

class HTTPLoginResponseSpec: QuickSpec {
    override func spec() {
        describe("HTTPLoginServerResponse") {
            context("decode") {
                func decode(string: String) -> HTTPLoginResponse {
                    try! JSONDecoder().decode(HTTPLoginResponse.self,
                                              from: string.data(using: .ascii)!)
                }

                context("success") {
                    let string = #"{"message":{"downloadUrl":"https://localhost/vernal_falls.tar","vernalFallsVersion":"1.4896"},"org":{"id":38,"name":"Training Ground"},"user":{"email":"sparta@example.com","id":4728,"name":"Test Sparta User"},"vernalFallsConfig":{"key":"value"}}"#
                    it("should de decoded") {
                        if case .success(let success) = decode(string: string) {
                            expect(success.message).notTo(beNil())
                        } else {
                            fail("should be success")
                        }
                    }
                    it("should re-encode without error") {
                        expect { try JSONEncoder().encode(decode(string: string)) }.notTo(throwError())
                    }
                }
                context("failure") {
                    let string = #"{"error":"server error"}"#
                    it("should de decoded") {
                        if case .failure(let failure) = decode(string: string) {
                            expect(failure.error) == "server error"
                        } else {
                            fail("should be success")
                        }
                    }
                    it("should re-encode without error") {
                        expect { try JSONEncoder().encode(decode(string: string)) }.notTo(throwError())
                    }
                }
            }
        }
    }
}
