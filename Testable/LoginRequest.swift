import Foundation

public func loginRequest(_ login: LoginRequest) -> URLRequest {
    let components = Init(URLComponents(string: login.baseUrlString)!) {
        if $0.path.isEmpty {
            $0.path = "/api/app-setup"
        }
        $0.queryItems = [.init(name: "email", value: login.username),
                         .init(name: "password", value: login.password),
                         .init(name: "client-id", value: "delete-me-please-test")]
    }
    return Init(URLRequest(url: components.url!)) {
        $0.httpMethod = "POST"
    }
}
