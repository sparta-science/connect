import Foundation

public struct ScienceInputs: Codable {
    let input: [Input]
}

struct Input: Codable {
    let load, explode, drive, avgMass: Double
    let maxVerticalJumpHeight: Double
    let gender: Int
    let id: String
}
