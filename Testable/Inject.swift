@propertyWrapper
public struct Inject<Service> {
    public init() {}
    public init(_ name: String) {
        self.name = name
    }

    private var service: Service?

    public var name: String?

    public var wrappedValue: Service {
        mutating get {
            if service == nil {
                service = DependencyInjection.resolver!.resolve(name: name)
            }
            return service!
        }
        mutating set {
            service = newValue
        }
    }
}
