import Foundation

public struct ScienceOutputs: Codable {
    public init(instances: [Instance] = []) {
        self.instances = instances
        details = "mega-flop-do-the-math: 08/26/2020, 15:46:50"
        version = "0.02-beta"
    }
    public let instances: [Instance]
    public let details, version: String
}

public struct Instance: Codable {
    public init(id: String, features: Features) {
        self.id = id
        self.features = features
    }
    public let features: Features
    public let id: String
}

public struct Features: Codable {
    public init(mskHealth: Double, approved: Bool) {
        self.mskHealth = mskHealth
        mskHealthApproved = approved
        relativeInjRate = 0
        prediction = 0
    }
    public let prediction, mskHealth, relativeInjRate: Double
    public let mskHealthApproved: Bool
}
