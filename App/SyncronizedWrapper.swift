import Swinject
import Testable

struct SyncronizedWrapper {
    let resolver: Resolver
    init(container: Container) {
        resolver = container.synchronize()
    }
}

extension SyncronizedWrapper: ResolveDependency {
    func resolve<Service>(_ type: Service.Type, name: String?) -> Service? {
        resolver.resolve(type, name: name)
    }
}
