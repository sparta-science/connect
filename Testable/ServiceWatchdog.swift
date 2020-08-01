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
    }
    @Inject var notifier: StateNotifier
    @Inject var launcherFactory: () -> ProcessLauncher
    @Inject("installation url")
    var installationURL: URL
    @Inject("user id")
    var userId: uid_t

    override public init() {
        super.init()
        notifier.start(receiver: onChange(state:))
    }

    static let stateCommands: [State: Command] = [
        .complete: .start,
        .login: .stop
    ]

    func launch(command: Command) {
        try? launcherFactory().run(command: "/bin/launchctl",
                                   args: [command.rawValue] + command.arguments(user: userId),
                                   in: installationURL)
    }

    func onChange(state: State) {
        Self.stateCommands[state].map { launch(command: $0) }
    }
}
