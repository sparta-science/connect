import Testable

final class MockInstaller: Installation {
    var didBegin: Login?
    func beginInstallation(login: Login) {
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
