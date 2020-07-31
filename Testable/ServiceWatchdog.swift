import Foundation

public class ServiceWatchdog {
    @Inject var notifier: StateNotifier
    @Inject var launcherFactory: () -> ProcessLauncher
    @Inject("installation url")
    var installationURL: URL

    public init() {
        notifier.start(receiver: onChange(state:))
    }

    func onChange(state: State) {
        try? launcherFactory().run(command: "/bin/launchctl", args: ["bootstrap"], in: installationURL)
    }
}
