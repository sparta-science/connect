public protocol ForcePlateDetection {
    func onChange(block: @escaping (_ name: String?) -> Void)
}

public protocol Starting {
    func start()
}
