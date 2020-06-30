public protocol ResolveDependency {
    func resolve<Service>(_: Service.Type, name: String?) -> Service?
}

public extension ResolveDependency {
    func resolve<Service>(name: String? = nil) -> Service? {
        resolve(Service.self, name: name)
    }
}
