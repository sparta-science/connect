import AppKit
import Foundation

public class ServiceWatchdog: NSObject {
    enum Command: String {
        case start = "bootstrap"
        case stop = "bootout"
        func arguments(user: uid_t) -> [String] {
            switch self {
            case .start:
                return ["gui/\(user)", "sparta_science.vernal_falls.plist"]
            case .stop:
                return ["gui/\(user)/sparta_science.vernal_falls"]
            }
        }
        func ignoreErrors() -> [Int32] {
            switch self {
            case .start:
                return [EALREADY]
            case .stop:
                return [ESRCH, EINPROGRESS]
            }
        }
    }
    @Inject var notifier: StateNotifier
    @Inject var launcherFactory: () -> ProcessLauncher
    @Inject("installation url")
    var installationURL: URL
    @Inject("start script url")
    var launchScriptURL: URL
    @Inject("stop script url")
    var stopScriptURL: URL
    @Inject("user id")
    var userId: uid_t
    @Inject var errorReporter: ErrorReporting
    @Inject var center: NotificationCenter
    let appQuitNotification = NSApplication.willTerminateNotification
    var observer: NSObjectProtocol?

    override public init() {
        super.init()
        notifier.start { [weak self] state in
            self?.onChange(state: state)
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        observer = center.addObserver(forName: appQuitNotification, object: nil, queue: nil) { [weak self] _ in
            self?.launch(command: .stop)
        }
    }

    static let stateCommands: [State: Command] = [
        .complete: .start,
        .login: .stop
    ]

    func launch(command: Command) {
        do {
            try launcherFactory().runShellScript(script: command == .start ? launchScriptURL : stopScriptURL,
                                                 in: installationURL)
        } catch {
            errorReporter.report(error: error)
        }
    }

    func onChange(state: State) {
        Self.stateCommands[state].map { launch(command: $0) }
    }
}
