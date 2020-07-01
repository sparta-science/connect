import Combine

public class Installer: NSObject {
    @Published public var state: State = .login
}

extension Installer: Installation {
    public func beginInstallation(login: Login) {
        state = .busy(value: .init())
    }

    public func cancelInstallation() {
        state = .login
    }

    public func uninstall() {
        state = .login
    }
}
