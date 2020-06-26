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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            progress.isCancellable = false
            progress.totalUnitCount = 3
            progress.completedUnitCount = 1
            self.state = .progress(value: progress)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                progress.completedUnitCount = 2
                self.state = .progress(value: progress)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    progress.completedUnitCount = 3
                    self.state = .progress(value: progress)
                    self.state = .complete
                }
            }
        }
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
