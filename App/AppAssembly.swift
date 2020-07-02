import Combine
import LetsMove
import Swinject
import SwinjectAutoregistration
import Testable

// swiftlint:disable:next static_operator
private func + <Service>(resolver: Resolver, service: Service.Type) -> Service {
    resolver ~> service
}

public extension Container {
    @discardableResult
    func register<Service>(name: StaticString? = nil, initializer: @escaping ((Resolver)) -> Service) -> ServiceEntry<Service> {
        register(Service.self, name: name.flatMap { $0.description }, factory: initializer)
    }

    @discardableResult
    func autoregister<Service>(name: StaticString? = nil, initializer: @escaping (()) -> Service) -> ServiceEntry<Service> {
        autoregister(Service.self, name: name.flatMap { $0.description }, initializer: initializer)
    }
}

struct AppAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: System
        container.autoregister { ProcessInfo.processInfo }
        container.autoregister { Bundle.main }
        container.autoregister { FileManager.default }
        container.autoregister { NSApplication.shared }
        container.autoregister { NotificationCenter.default }
        container.autoregister {
            NSStatusBar.system
                .statusItem(withLength: NSStatusItem.squareLength)
        }
        container.register { $0 + NSApplication.self as ApplicationAdapter }

        // MARK: Third party
        container.autoregister(name: "move to applications") { PFMoveToApplicationsFolderIfNecessary }
        
        // MARK: Application
        container.autoregister { Installer() }
        container.register { $0 + Installer.self as Installation }
        container.register(AnyPublisher<State, Never>.self) {
            ($0 ~> Installer.self).$state.eraseToAnyPublisher()
        }
        container.autoregister { ErrorReporter() }
        container.autoregister { $0 + ErrorReporter.self as ErrorReporting }        
    }
}
