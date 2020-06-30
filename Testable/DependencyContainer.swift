public protocol DependencyContainer {
    func getResolver() -> ResolveDependency
}
