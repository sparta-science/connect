enum DebugFileServer: String, CaseIterable {
    case failure = "simulate install failure"
    case successGators = "simulate SF State Gators"
    case successBananaSlug = "simulate UC Santa Cruz"

    static let files: [Self: String] = [
        .failure: "successful-response-invalid-tar",
        .successGators: "successful-response-sf-state-gators",
        .successBananaSlug: "successful-response-uc-santa-cruz"
    ]
    func fileName() -> String {
        Self.files[self]!
    }
}
