import Foundation

public func loginRequest(_ login: Login) -> URLRequest {
    let backend = BackEnd(rawValue: login.environment)!
    let loginUrl = backend.baseUrl().appendingPathComponent("api/app-setup")
    var components = URLComponents(url: loginUrl, resolvingAgainstBaseURL: true)!
    components.queryItems = [.init(name: "email", value: login.username),
                             .init(name: "password", value: login.password),
                             .init(name: "client-id", value: "delete-me-please-test")]
    var request = URLRequest(url: components.url!)
    request.httpMethod = "POST"
    return request
}
