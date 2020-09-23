import Nimble
import Quick
import SpartaConnect

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
