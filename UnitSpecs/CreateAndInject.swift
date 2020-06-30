import Testable

protocol InjectedMock {
    init()
    static func createAndInject() -> Self
}

extension InjectedMock {
    static func createAndInject() -> Self {
        TestDependency.inject()
    }
}

protocol CreateAndInject: AnyObject, InjectedMock {
    associatedtype ActAs
    static func createAndInject(_ name: String?) -> Self
}

extension CreateAndInject {
    static func createAndInjectFactory() -> Self {
        Init(Self()) { value in
            let made = value as! ActAs
            TestDependency.register(Inject({ made }))
        }
    }
    static func createAndInject(_ name: String? = nil) -> Self {
        Init(Self()) {
            TestDependency.register(Inject<ActAs>($0 as! ActAs, name: name))
        }
    }
}

func createAndInject<Type>(_ value: Type) -> Type! {
    Init(value) {
        TestDependency.register(Inject<Type>($0))
    }
}

extension MockApplication: CreateAndInject {
    typealias ActAs = ApplicationAdapter
}
