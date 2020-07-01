import Nimble
import Quick
import Testable

class HTTPLoginResponseSpec: QuickSpec {
    override func spec() {
        context("JSON serialize") {
            describe(Organization.self) {
                it("should serialize") {
                    let org = Init(Organization(id: 1234, name: "Falcons")) {
                        $0.logoUrl = "http://example.com/logo.png"
                        $0.touchIconUrl = "http://Falcons.com/icon.png"
                    }
                    
                    let data = try! JSONEncoder().encode(org)
                    let string = String(data: data, encoding: .ascii)
                    expect(string) == #"{"logoUrl":"http:\/\/example.com\/logo.png","id":1234,"name":"Falcons","touchIconUrl":"http:\/\/Falcons.com\/icon.png"}"#
                }
            }
        }
    }
}
