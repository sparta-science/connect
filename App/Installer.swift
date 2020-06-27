import Foundation

public enum State: Equatable {
    case login
    case busy(value: Progress)
    case complete
    func onlyProgress() -> Progress? {
        if case let .busy(value: progress) = self {
            return progress
        } else {
            return nil
        }
    }
}

public class Installer: NSObject {
    public static let shared = Installer()
    @Published public var state: State = .login
    @objc func downloadStep() {
        if case let .busy(value: value) = state {
            if value.isFinished {
                state = .complete
            } else {
                value.completedUnitCount += 1
                state = .busy(value: value)
                perform(#selector(downloadStep), with: nil, afterDelay: 0.1)
            }
        }
    }
    @objc func downloadStart() {
        let progress = Progress()
        progress.isCancellable = true
        progress.totalUnitCount = 20
        progress.completedUnitCount = 1
        self.state = .busy(value: progress)
        perform(#selector(downloadStep), with: nil, afterDelay: 1)
    }
    func beginInstallation(login: Login) {
        assert(state == .login)
        let progress = Progress()
        progress.kind = .file
        progress.fileOperationKind = .receiving
        progress.isCancellable = false
        state = .busy(value: progress)
        perform(#selector(downloadStart), with: nil, afterDelay: 1)
    }
    func cancelInstallation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let progress = Progress()
        progress.isCancellable = false
        state = .busy(value: progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.state = .login
        }
    }
    func uninstall() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let progress = Progress()
        progress.isCancellable = false
        state = .busy(value: progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state = .login
        }
    }
}
