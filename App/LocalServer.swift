import Foundation
import Swifter
import Testable

class LocalServer: NSObject {
    var server: HttpServer?
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    func handleOffline(data: Data) -> HttpResponseBody {
        if let json = try? self.decoder.decode(ScienceInputs.self, from: data) {
            print(json)
        }
        return .json(["hello"])
    }
    func startServer() {
        server = HttpServer()
        if let server = server {
            server["/offline"] = { request in
                return .ok(self.handleOffline(data: Data(request.body)))
            }
            // swiftlint:disable:next force_try
            try! server.start(4_080)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        startServer()
    }
}
