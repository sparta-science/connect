import Swinject
import Testable

private func createSwinjectContainer() -> Container {
    Init(Container(defaultObjectScope: .container)) {
        Container.loggingFunction = nil
        Configure(Assembler(container: $0)) {
            $0.apply(assembly: AppAssembly())
        }
    }
}

extension Bundle: DependencyContainer {
    public func createResolver() -> ResolveDependency {
        SyncronizedWrapper(container: createSwinjectContainer())
    }
}
