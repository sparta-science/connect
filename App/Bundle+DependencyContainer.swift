import Testable
import Swinject

private func createSwinjectContainer() -> Container {
    Init(Container(defaultObjectScope: .container)) {
        Container.loggingFunction = nil
        Configure(Assembler(container: $0)) {
            $0.apply(assembly: AppAssembly())
        }
    }
}

extension Bundle: DependencyContainer {
    public func getResolver() -> ResolveDependency {
        SyncronizedWrapper(container: createSwinjectContainer())
    }
}