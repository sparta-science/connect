import NSBundle_LoginItem

public class LoginItemManager: NSObject {
    let bundle = Bundle.main
    @objc
    public var openAtLogin: Bool {
        get {
            bundle.isLoginItemEnabled()
        }
        set {
            if newValue {
                bundle.enableLoginItem()
            } else {
                bundle.disableLoginItem()
            }
        }
    }
}
