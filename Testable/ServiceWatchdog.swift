import AppKit
import Foundation

public class ServiceWatchdog: NSObject {
    enum Command {
        case start, stop
    }
    @Inject var notifier: StateNotifier
    @Inject var launcherFactory: () -> ProcessLauncher
    @Inject("installation url")
    var installationURL: URL
    @Inject("start script url")
    var startScriptURL: URL
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

    func launch(script: URL, in folder: URL) throws {
        try launcherFactory().runShellScript(script: script, in: folder)
    }

    func launch(command: Command) {
        do {
            switch command {
            case .start:
                try launch(script: startScriptURL, in: installationURL)
            case .stop:
                try launch(script: stopScriptURL, in: URL(fileURLWithPath: "/tmp"))
            }
        } catch {
            errorReporter.report(error: error)
        }
    }

    func onChange(state: State) {
        Self.stateCommands[state].map { launch(command: $0) }
    }
}
