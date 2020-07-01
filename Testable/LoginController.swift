import Cocoa

public class LoginController: NSViewController {
    @objc var hideEnvironments: Bool = isReleaseBuild()
    @objc public let login = Login()
    @Inject var installer: Installation
    @Inject var processInfo: ProcessInfo

    @IBAction public func connectAction(_ sender: NSButton) {
        installer.beginInstallation(login: login)
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        #if DEBUG
        let env = processInfo.environment
        if let debugBackend = env["debug-backend"], !debugBackend.isEmpty {
            login.environment = debugBackend
        }
        login.username = env["debug-email"]
        login.password = env["debug-password"]
        #endif
    }
}
