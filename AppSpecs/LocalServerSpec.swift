import Nimble
import Quick
import SpartaConnect
import Swifter

class LocalServerSpec: QuickSpec {
    override func spec() {
        describe(LocalServer.self) {
            describe("/msk-health") {
                context("invalid request") {
                    it("should respond with an error") {
                        let dataResponse = try! Data(contentsOf: URL(string: "http://localhost:4080/msk-health")!)
                        let parsed = try! JSONSerialization.jsonObject(with: dataResponse) as! NSDictionary
                        expect(parsed["errorMessage"] as? String) == "dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: \"The given data was not valid JSON.\", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 \"No value.\" UserInfo={NSDebugDescription=No value.})))"
                        expect(parsed["errorType"] as? String) == "DecodingError"
                        expect(parsed["localizedDescription"] as? String) == "The data couldn’t be read because it isn’t in the correct format."

                        let stackTrace = parsed["stackTrace"] as? NSArray
                        expect(stackTrace?.count) > 10
                        expect(stackTrace?[0] as? String).to(beginWith("0   SpartaConnect                       0x0000000"))
                    }
                }
                context("valid request") {
                    var server: HttpServer!
                    beforeEach {
                        server = Injected.instance
                    }
                    func cleanString(data: Data) -> String? {
                        String(data: data, encoding: .ascii)?.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    it("should respond with an json") {
                        let request = HttpRequest()
                        let sampleRequest = testData("msk-health-request.json")
                        let array = [UInt8](sampleRequest)
                        request.path = "msk-health"
                        request.body = array
                        let result = server.dispatch(request)
                        let response = result.1(request)
                        if case .ok(let body) = response, case .data(let data, _) = body {
                            expect(cleanString(data: data)) == cleanString(data: testData("msk-health-response.json"))
                        } else {
                            fail("should be ok")
                        }
                    }
                }
            }
            describe("/health-check") {
                it("should return ok") {
                    let dataResponse = try! Data(contentsOf: URL(string: "http://localhost:4080/health-check")!)
                    expect(String(data: dataResponse, encoding: .utf8)) == "ok"
                }
            }
        }
    }
}
