import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let updater = SUUpdater.shared()!

    @IBAction func checkForUpdates(_ sender: Any) {
        updater.checkForUpdates(sender)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        assert(updater.automaticallyChecksForUpdates)
        updater.automaticallyDownloadsUpdates = true
        assert(updater.automaticallyDownloadsUpdates)
    }
}
