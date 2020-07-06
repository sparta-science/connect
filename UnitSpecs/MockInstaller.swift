import Testable

final class MockInstaller: Installation {
    var didBegin: LoginRequest?
    func beginInstallation(login: LoginRequest) {
        didBegin = login
    }

    var didCall: String?
    func cancelInstallation() {
        didCall = #function
    }

    func uninstall() {
        didCall = #function
    }
}

extension MockInstaller: CreateAndInject {
    typealias ActAs = Installation
}
