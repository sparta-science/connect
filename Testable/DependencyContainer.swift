public protocol DependencyContainer {
    static func createResolver() -> ResolveDependency
}
