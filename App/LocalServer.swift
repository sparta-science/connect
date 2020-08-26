import Foundation
import Swifter

class LocalServer: NSObject {
    var server: HttpServer?
    func startServer() {
        server = HttpServer()
        if let server = server {
            server["/hello"] = { .ok(.htmlBody("You asked for \($0)")) }
            // swiftlint:disable:next force_try
            try! server.start(4_080)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        startServer()
    }
}
