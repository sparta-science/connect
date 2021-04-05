import Nimble
@testable import Quick
@testable import Testable

extension Inject: Hashable {
    public static func == (lhs: Inject<Service>, rhs: Inject<Service>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: Service.self))
        if let name = name {
            hasher.combine(name)
        }
    }

    init(_ service: Service, name: String? = nil) {
        self.init(type: Service.self, name: name)
        self.wrappedValue = service
    }

    init(type: Service.Type, name: String? = nil) {
        if let name = name {
            self.init(name)
        } else {
            self.init()
        }
    }
}

class TestResolver: ResolveDependency {
    var dependencies: [Int: Any] = [:]
    var used: Set<Int> = []

    func register(_ values: [AnyHashable]) {
        values.forEach {
            dependencies[$0.hashValue] = $0
        }
    }
    func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        let lookup = Inject<Service>(type: serviceType, name: name)
        let key = lookup.hashValue
        used.insert(key)
        var injected = dependencies[key] as? Inject<Service>
        if injected == nil {
            let failure = "no test dependency: \(name ?? "") \(serviceType)"
            if let site = World.sharedWorld.currentExampleMetadata?.example.callsite {
                QuickSpec.current.recordFailure(withDescription:
                """


                \(URL(fileURLWithPath: site.file).lastPathComponent):\(site.line)

                \(failure)

                """, inFile: site.file, atLine: Int(site.line), expected: false)
            } else {
                assertionFailure(failure)
            }
        }
        return injected!.wrappedValue
    }
}

extension TestResolver: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        test dependencies:
        \(dependencies.debugDescription)
        used:
        \(used)
        """
    }
}

enum TestDependency {
    static var testResolver = TestResolver()
    static func inject<T: InjectedMock>() -> T {
        Init(T()) {
            register(Inject($0))
        }
    }
    static func inject<T: CreateAndInject>(_ mockFactory: @escaping () -> T) {
        register(Inject({ mockFactory() as! T.ActAs }))
    }
    static func inject<T: CreateAndInject>(_ mock: T, name: String? = nil) {
        register(Inject(mock as! T.ActAs, name: name))
    }
    static func inject<T: TypeInject>(_ mockType: T.Type, name: String? = nil) {
        _ = mockType.createAndInjectType(name)
    }
    static func register(_ values: AnyHashable...) {
        testResolver.register(values)
    }
}

class DependencyInjectionConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach {
            TestDependency.testResolver = TestResolver()
            DependencyInjection.resolver = TestDependency.testResolver
        }
        configuration.afterEach { exampleMetadata in
            let testResolver = TestDependency.testResolver
            let location = exampleMetadata.example.callsite
            expect(file: location.file,
                   line: location.line,
                   testResolver.used).to(haveCount(testResolver.dependencies.count),
                                           description:
                    "unused dependencies: \(testResolver.dependencies.filter { !testResolver.used.contains($0.key) })")
            DependencyInjection.resolver = TestResolver()
        }
    }
}
