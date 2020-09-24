import EdgeScience
import Foundation
import Swifter
import Testable

extension MskWrapper {
    func convert(predictions: [Decimal?], ids: [String]) -> ScienceOutputs {
        let features = predictions.map { mskHealth -> Features in
            if let mskHealth = mskHealth {
                return Features(mskHealth: mskHealth, approved: true)
            }
            return Features(mskHealth: 0, approved: false)
        }
        let instances = zip(ids, features).map { Instance(id: $0, features: $1) }
        return ScienceOutputs(instances: instances)
    }
    func predict(inputs: ScienceInputs) -> ScienceOutputs {
        convert(predictions: predictMskHealth(inputs).map {
            $0.map {
                let scale = 1

                var value1 = Decimal($0)
                var roundedValue1 = Decimal()

                NSDecimalRound(&roundedValue1, &value1, scale, NSDecimalNumber.RoundingMode.plain)

                return roundedValue1
            }
        },
                ids: inputs.input.map { $0.id })
    }
}

public class LocalServer: NSObject {
    @Inject var science: MskWrapper

    @Inject var server: HttpServer
    let decoder = Init(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    let encoder = Init(JSONEncoder()) {
        $0.keyEncodingStrategy = .convertToSnakeCase
    }
    func handleMskHealthRequest(data: Data) -> HttpResponseBody {
        if let inputs = try? decoder.decode(ScienceInputs.self, from: data),
            let encoded = try? encoder.encode(science.predict(inputs: inputs)) {
            return .data(encoded)
        }
        return .json(["something went wrong"])
    }
    func startServer() {
        server["/msk-health"] = { request in
            .ok(self.handleMskHealthRequest(data: Data(request.body)))
        }
        server["/health-check"] = { request in
            .ok(.html("ok"))
        }
        // swiftlint:disable:next force_try
        try! server.start(4_080)
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        startServer()
    }
}
