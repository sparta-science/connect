import Nimble
import Quick
import SpartaConnect

class LocalServerSpec: QuickSpec {
    override func spec() {
        describe(LocalServer.self) {
            describe("/offline") {
                context("invalid request") {
                    it("should respond with an error") {
                        let dataResponse = try! Data(contentsOf: URL(string: "http://localhost:4080/offline")!)
                        expect(String(data: dataResponse, encoding: .utf8)) == "[\"something went wrong\"]"
                    }
                }
            }
        }
    }
}
