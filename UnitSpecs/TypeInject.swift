import Testable

protocol TypeInject {
    associatedtype TypeActAs
    init()
}

extension TypeInject {
    static func createAndInjectType(_ name: String? = nil) -> Self {
        Init(Self()) {
            TestDependency.register(Inject($0))
            TestDependency.register(Inject<TypeActAs>(type(of: $0) as! TypeActAs, name: name))
        }
    }
}
