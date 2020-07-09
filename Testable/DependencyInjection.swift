public enum DependencyInjection {
    private static func createResolver() -> ResolveDependency? {
        (self as? DependencyContainer.Type)?.createResolver()
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
