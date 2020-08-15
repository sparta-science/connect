enum DebugFileServer: String, CaseIterable {
    case failure = "simulate install failure"
    case success = "simulate SF State Gators"
    case bananaSlug = "simulate UC Santa Cruz"

    static let files: [Self: String] = [
        .failure: "successful-response-invalid-tar",
        .success: "successful-response-valid-archive",
        .bananaSlug: "successful-response-uc-santa-cruz"
    ]
    func fileName() -> String {
        Self.files[self]!
    }
}
