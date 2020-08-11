import Foundation

public func percentEncode(_ string: String) -> String {
    string.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
}

public func loginRequest(_ login: LoginRequest, clientId: String) -> URLRequest {
    let components = Init(URLComponents(string: login.baseUrlString)!) {
        if $0.path.isEmpty {
            $0.path = "/api/app-setup"
        }
        $0.percentEncodedQueryItems = [ "email": login.username,
                                        "password": login.password,
                                        "client-id": clientId]
            .sorted(by: <)
            .map { .init(name: $0.key, value: percentEncode($0.value)) }
    }
    return Init(URLRequest(url: components.url!)) {
        $0.httpMethod = "POST"
    }
}
