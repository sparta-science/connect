import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func checkForUpdates(_ sender: Any) {
        let updater = SUUpdater.shared()!
        updater.checkForUpdates(sender)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let updater = SUUpdater.shared()!
        assert(updater.automaticallyChecksForUpdates)
        updater.automaticallyDownloadsUpdates = true
        assert(updater.automaticallyDownloadsUpdates)
    }
}
