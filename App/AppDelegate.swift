import AppKit
import LetsMove
import NSBundle_LoginItem

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        PFMoveToApplicationsFolderIfNecessary()
        updateLaunchAtLogin()
    }
    @IBOutlet weak var openAtLogin: NSMenuItem!
    
    @IBAction func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        if sender.state == .on {
            Bundle.main.disableLoginItem()
        } else {
            Bundle.main.enableLoginItem()
        }
        updateLaunchAtLogin()
    }
    
    func updateLaunchAtLogin() {
        openAtLogin.state = Bundle.main.isLoginItemEnabled() ? .on : .off
    }
}
