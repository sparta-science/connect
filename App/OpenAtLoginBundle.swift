import NSBundle_LoginItem

extension Bundle {
    @objc
    public var openAtLogin: Bool {
        get {
            isLoginItemEnabled()
        }
        set {
            setEnabledAtLogin(newValue)
        }
    }
}

public class OpenAtLoginBundle: NSObject {
    public override func awakeAfter(using coder: NSCoder) -> Any? {
        Bundle.main
    }
}
