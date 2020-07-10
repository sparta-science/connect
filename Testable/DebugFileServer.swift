enum DebugFileServer: String, CaseIterable {
    case failure = "simulate install failure"
    case success = "simulate install success"

    static let files: [Self: String] = [
        .failure: "successful-response-invalid-tar",
        .success: "successful-response-valid-archive"
    ]
    func fileName() -> String {
        Self.files[self]!
    }
}
