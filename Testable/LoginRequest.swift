import Foundation

public func loginRequest(_ login: Login) -> URLRequest {
    let backend = BackEnd(rawValue: login.environment)!
    let loginUrl = backend.baseUrl()
    let components = Init(URLComponents(string: loginUrl.absoluteString)!) {
        $0.path = "/api/app-setup"
        $0.queryItems = [.init(name: "email", value: login.username),
                         .init(name: "password", value: login.password),
                         .init(name: "client-id", value: "delete-me-please-test")]
    }
    return Init(URLRequest(url: components.url!)) {
        $0.httpMethod = "POST"
    }
}
