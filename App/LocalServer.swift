import EdgeScience
import Foundation
import Swifter
import Testable

extension MskWrapper {
    func convert(predictions: [Double?]) -> ScienceOutputs {
        let instances = predictions.map { mskHealth in
            if let mskHealth = mskHealth {
                return Features(mskHealth: mskHealth, approved: true)
            } else {
                return Features(mskHealth: 0, approved: false)
            }
        }
        .map { Instance(id: "TODO: bs pz we need to pass shas", features: $0) }
        return ScienceOutputs(instances: instances)
    }
}

public class LocalServer: NSObject {
    let science = MskWrapper()

    var server: HttpServer?
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    let encoder = Init(JSONEncoder()) {
        $0.keyEncodingStrategy = .convertToSnakeCase
    }
    func handleOffline(data: Data) -> HttpResponseBody {
        if let inputs = try? decoder.decode(ScienceInputs.self, from: data) {
            let outputs = science.convert(predictions: science.predictMskHealth(inputs))
            if let encoded = try? encoder.encode(outputs) {
                return .data(encoded)
            }
            return .json(["something went wrong"])
        }
        return .json(["something went wrong"])
    }
    func startServer() {
        server = HttpServer()
        if let server = server {
            server["/msk-health"] = { request in
                .ok(self.handleOffline(data: Data(request.body)))
            }
            server["/health-check"] = { request in
                .ok(.html("ok"))
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
