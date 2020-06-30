import Testable
import Swinject

private func createSwinjectContainer() -> Container {
    let container = Container(defaultObjectScope: .container)
    Container.loggingFunction = nil

    let assembler = Assembler(container: container)
    assembler.apply(assembly: AppAssembly())
    container.register(Assembler.self) { _ in
        assembler
    }
    #if targetEnvironment(simulator)
        assembler.apply(assembly: SimulatorTestAssembly())
    #endif
    return container
}

extension Bundle: DependencyContainer {
    public func getResolver() -> ResolveDependency {
        SyncronizedWrapper(container: createSwinjectContainer())
    }
}
