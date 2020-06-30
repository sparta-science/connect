import class AppKit.NSApplication

public protocol ApplicationAdapter {
    @discardableResult
    func setActivationPolicy(_ activationPolicy: NSApplication.ActivationPolicy) -> Bool
    func activate(ignoringOtherApps flag: Bool)
}

public extension ApplicationAdapter {
}

extension NSApplication: ApplicationAdapter {}
