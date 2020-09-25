public enum DebugApiServer: String, CaseIterable {
    // swiftlint:disable explicit_enum_raw_value
    case localhost
    case staging
    func server() -> ApiServer {
        switch self {
        case .localhost:
            return .localhost
        case .staging:
            return .staging
        }
    }
}

public class DebugServerLocator: ServerLocator {
    @Inject var bundle: Bundle

    override public var availableServers: [String] {
        super.availableServers
            + DebugApiServer.allCases.map { $0.rawValue }
            + DebugFileServer.allCases.map { $0.rawValue }
    }

    override func baseUrlString(_ server: String) -> String {
        if let file = DebugFileServer(rawValue: server) {
            return bundle.url(forResource: file.fileName(),
                              withExtension: "json")!.absoluteString
        } else if let debugServer = DebugApiServer(rawValue: server) {
            return debugServer.server().serverUrlString()
        }
        return super.baseUrlString(server)
    }
}
