public protocol DependencyContainer {
    func createResolver() -> ResolveDependency
}
