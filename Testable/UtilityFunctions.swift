public func isReleaseBuild() -> Bool {
    !isDebugBuild()
}

public func isDebugBuild() -> Bool {
    _isDebugAssertConfiguration()
}
