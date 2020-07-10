public class DebugServerLocator: ServerLocator {
    @Inject var bundle: Bundle

    override public var availableServers: [String] {
        super.availableServers
            + DebugFileServer.allCases.map { $0.rawValue }
    }

    override func baseUrlString(_ server: String) -> String {
        guard let file = DebugFileServer(rawValue: server) else {
            return super.baseUrlString(server)
        }
        return bundle.url(forResource: file.fileName(),
                          withExtension: "json")!.absoluteString
    }
}
