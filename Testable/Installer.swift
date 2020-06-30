import Combine

public class Installer: NSObject {
    @Published public var state: State = .login
}

extension Installer: Installation {
    public var statePublisher: AnyPublisher<State, Never> {
        $state.eraseToAnyPublisher()
    }

    public func beginInstallation(login: Login) {
    }

    public func cancelInstallation() {
    }

    public func uninstall() {
    }
}
