import Foundation
import NSBundle_LoginItem

class LoginItemManager: NSObject {
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
