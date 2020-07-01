import Combine

public class Installer: NSObject {
    @Published public var state: State = .login
}

extension Installer: Installation {
    public func beginInstallation(login: Login) {
    }

    public func cancelInstallation() {
    }

    public func uninstall() {
    }
}
