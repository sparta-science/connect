import NSBundle_LoginItem

public class LoginItemManager: NSObject {
    let bundle = Bundle.main
    @objc
    public var openAtLogin: Bool {
        get {
            bundle.isLoginItemEnabled()
        }
        set {
            bundle.setEnabledAtLogin(newValue)
        }
    }
}
