import Foundation

enum State: Equatable {
    case login
    case progress(value: Progress)
    case complete
}

class Installer: NSObject {
    static let shared = Installer()
    @Published var state: State = .login
    @objc func downloadStep() {
        if case let .progress(value: value) = state {
            if value.isFinished {
                state = .complete
            } else {
                value.completedUnitCount += 1
                state = .progress(value: value)
                perform(#selector(downloadStep), with: nil, afterDelay: 1)
            }
        }
    }
    @objc func downloadStart() {
        let progress = Progress()
        progress.isCancellable = true
        progress.totalUnitCount = 5
        progress.completedUnitCount = 1
        self.state = .progress(value: progress)
        perform(#selector(downloadStep), with: nil, afterDelay: 1)
    }
    func beginInstallation(login: Login) {
        assert(state == .login)
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .receiving
        progress.isCancellable = false
        state = .progress(value: progress)
        perform(#selector(downloadStart), with: nil, afterDelay: 1)
    }
    func cancelInstallation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let progress = Progress()
        progress.isCancellable = false
        state = .progress(value: progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.state = .login
        }
    }
    func uninstall() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let progress = Progress()
        progress.isCancellable = false
        state = .progress(value: progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state = .login
        }
    }
}
