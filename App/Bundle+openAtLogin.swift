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
