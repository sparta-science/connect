import Testable

final class MockLocator: ServerLocatorProtocol {
    var availableServers: [String] = []

    func baseUrlString(_ server: String) -> String {
        "base url string"
    }

    var fakeLoginRequest = LoginRequest()

    func loginRequest(_ login: Login) -> LoginRequest {
        fakeLoginRequest
    }
}

extension MockLocator: CreateAndInject {
    typealias ActAs = ServerLocatorProtocol
}
