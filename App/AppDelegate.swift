import AppKit
import LetsMove

var g_touchVC : MyTouchViewController!

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        PFMoveToApplicationsFolderIfNecessary()
    }
}
