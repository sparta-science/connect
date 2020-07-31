import Foundation

public class ServiceWatchdog: NSObject {
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

    func onChange(state: State) {
        switch state {
        case .complete:
            try? launcherFactory().run(command: "/bin/launchctl",
                                       args: ["bootstrap", "gui/\(userId)", "sparta_science.vernal_falls.plist"],
                                       in: installationURL)
        case .login:
            try? launcherFactory().run(command: "/bin/launchctl",
                                       args: ["bootout", "gui/\(userId)", "sparta_science.vernal_falls"],
                                       in: installationURL)
        default:
            break
        }
    }
}
