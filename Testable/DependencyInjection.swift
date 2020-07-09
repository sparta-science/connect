public enum DependencyInjection {
    static func createResolver() -> ResolveDependency? {
        (Bundle.main as? DependencyContainer)?.createResolver()
    }
    private static var privateResolver: ResolveDependency?
    internal static var resolver: ResolveDependency? {
        get {
            if privateResolver == nil {
                privateResolver = createResolver()
            }
            return privateResolver
        }
        set {
            privateResolver = newValue
        }
    }
}
