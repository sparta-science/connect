import AppKit
import LetsMove
import NSBundle_LoginItem

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        PFMoveToApplicationsFolderIfNecessary()
        updateLaunchAtLogin()
    }
    
    @IBAction func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        if sender.state == .on {
            Bundle.main.disableLoginItem()
        } else {
            Bundle.main.enableLoginItem()
        }
        updateLaunchAtLogin()
    }
    
    func updateLaunchAtLogin() {
        let launchAtLoginMenuItem = NSApp.mainMenu!.item(withTag: 3)
        launchAtLoginMenuItem?.state = Bundle.main.isLoginItemEnabled() ? .on : .off
    }
}
