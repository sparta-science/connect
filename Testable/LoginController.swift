import Cocoa

public class LoginController: NSViewController {
    @objc var hideEnvironments: Bool = isReleaseBuild()
    @objc public let login = Login()
    @Inject var installer: Installation

    @IBAction public func connectAction(_ sender: NSButton) {
        installer.beginInstallation(login: login)
    }
}
