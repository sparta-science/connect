import Testable
import class AppKit.NSApplication

class MockApplication: NSObject {
    var didSetPolicy: NSApplication.ActivationPolicy?
    var didActivateWithFlag: Bool?
}

extension MockApplication: ApplicationAdapter {
    func setActivationPolicy(_ activationPolicy: NSApplication.ActivationPolicy) -> Bool {
        didSetPolicy = activationPolicy
        return true
    }
    
    func activate(ignoringOtherApps flag: Bool) {
        didActivateWithFlag = flag
    }
}
