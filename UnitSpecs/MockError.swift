import Foundation

class MockError: LocalizedError {
    var errorDescription: String? {
        NSLocalizedString("mock error", comment: "error only used in tests")
    }
}
