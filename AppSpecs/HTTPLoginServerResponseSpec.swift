import Nimble
import Quick
import SpartaConnect

class HTTPLoginServerResponseSpec: QuickSpec {
    override func spec() {
        describe("HTTPLoginServerResponse") {
            context("decode") {
                let decoder = JSONDecoder()
                
                context("success") {
                    it("should de decoded") {
                        let string = #"{"message":{"downloadUrl":"https://localhost/vernal_falls.tar","vernalFallsVersion":"1.4896"},"org":{"id":38,"name":"Training Ground"},"user":{"email":"sparta@example.com","id":4728,"name":"Test Sparta User"},"vernalFallsConfig":{"key":"value"}}"#
                        let data = string.data(using: .ascii)!
                        let decoded = try! decoder.decode(HTTPLoginResponse.self, from: data)
                        if case .success(value: let success) = decoded {
                            expect(success.message).notTo(beNil())
                        } else {
                            fail("should be success")
                        }
                    }
                }
                context("failure") {
                    it("should de decoded") {
                        let string = #"{"error":"server error"}"#
                        let data = string.data(using: .ascii)!
                        let decoded = try! decoder.decode(HTTPLoginResponse.self, from: data)
                        if case .failure(value: let failure) = decoded {
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
