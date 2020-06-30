import Combine

public class Installer: NSObject {
}

extension Installer: Installation {
    public var statePublisher: AnyPublisher<State, Never> {
        fatalError()
    }

    public func beginInstallation(login: Login) {
    }

    public func cancelInstallation() {
    }

    public func uninstall() {
    }
}
