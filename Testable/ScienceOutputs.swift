import Foundation

public struct ScienceOutputs: Codable {
    public init() {
        instances = []
        details = "mega-flop-do-the-math: 08/26/2020, 15:46:50"
        version = "0.02-beta"
    }
    public let instances: [Instance]
    public let details, version: String
}

public struct Instance: Codable {
    let features: Features
    let id: String
}

public struct Features: Codable {
    let prediction, mskHealth, relativeInjRate: Double
    let mskHealthApproved: Bool
}
