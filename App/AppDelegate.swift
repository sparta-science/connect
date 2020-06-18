import AppKit
import LetsMove

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        PFMoveToApplicationsFolderIfNecessary()
    }
	
	@IBAction func enterCredentials(_ sender: Any?) {
		CredentialsInterface.showCredentials()
	}
}
