import Foundation

public struct ScienceInputs: Codable {
    public let input: [Input]

    public struct Input: Codable {
        public let load, explode, drive, avgMass: Double
        public let maxVerticalJumpHeight: Double
        public let gender: Int
        public let id: String
    }
}

