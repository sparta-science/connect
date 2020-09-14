import Foundation
import Swifter
import Testable

public class LocalServer: NSObject {
    var server: HttpServer?
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    let encoder = Init(JSONEncoder()) {
        $0.keyEncodingStrategy = .convertToSnakeCase
    }
    func handleOffline(data: Data) -> HttpResponseBody {
        if let inputs = try? decoder.decode(ScienceInputs.self, from: data) {
            let outputs = science(inputs: inputs)
            if let encoded = try? encoder.encode(outputs) {
                return .data(encoded)
            }
        }
        return .json(["something went wrong"])
    }
    func startServer() {
        server = HttpServer()
        if let server = server {
            server["/offline"] = { request in
                .ok(self.handleOffline(data: Data(request.body)))
            }
            // swiftlint:disable:next force_try
            try! server.start(4_080)
        }
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        startServer()
    }
}
