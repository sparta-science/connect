import Foundation

enum State: Equatable {
    case login
    case progress(value: Progress)
    case complete
}

class Installer: NSObject {
    static let shared = Installer()
    @Published var state: State = .login
    
    func beginInstallation(login: Login) {
        assert(state == .login)
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .receiving
        state = .progress(value: progress)
    }
    func cancelInstallation() {
        let progress = Progress()
        progress.isCancellable = false
        state = .progress(value: progress)
        state = .login
    }
    func uninstall() {
        state = .login
    }
}
