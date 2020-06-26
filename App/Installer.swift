import Foundation

enum State {
    case login
    case progress
    case complete
}

class Installer: NSObject {
    static let shared = Installer()
    @Published var state: State = .login
    
    func beginInstallation(login: Login) {
        assert(state == .login)
        state = .progress
    }
    func cancelInstallation() {
        state = .login
    }
    func uninstall() {
        state = .login
    }
}
