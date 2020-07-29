import Foundation

public func percentEncode(_ string: String) -> String {
    string.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
}

public func loginRequest(_ login: LoginRequest) -> URLRequest {
    let components = Init(URLComponents(string: login.baseUrlString)!) {
        if $0.path.isEmpty {
            $0.path = "/api/app-setup"
        }
        $0.percentEncodedQueryItems = [URLQueryItem(name: "email", value: percentEncode(login.username)),
                                       URLQueryItem(name: "password", value: percentEncode(login.password)),
                                       URLQueryItem(name: "client-id", value: "delete-me-please-test")]
    }
    return Init(URLRequest(url: components.url!)) {
        $0.httpMethod = "POST"
    }
}
