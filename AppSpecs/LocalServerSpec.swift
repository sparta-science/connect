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
                        expect(String(data: dataResponse, encoding: .utf8)) == "[\"something went wrong\"]"
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
                        if case .ok(let body) = response, case .data(let data) = body {
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
