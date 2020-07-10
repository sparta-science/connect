import Testable

final class MockLocator: ServerLocatorProtocol {
    var availableServers: [String] = []

    var fakeLoginRequest = LoginRequest()

    func loginRequest(_ login: Login) -> LoginRequest {
        fakeLoginRequest
    }
}

extension MockLocator: CreateAndInject {
    typealias ActAs = ServerLocatorProtocol
}
