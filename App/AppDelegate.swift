import AppKit
import LetsMove
import NSBundle_LoginItem

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        PFMoveToApplicationsFolderIfNecessary()
    }
}
