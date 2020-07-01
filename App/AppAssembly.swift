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
        container.autoregister { ProcessInfo.processInfo }
        container.autoregister { Bundle.main }
        container.autoregister { Installer() }
        container.register { $0 + Installer.self as Installation }
        container.register(AnyPublisher<State, Never>.self) {
            ($0 ~> Installer.self).$state.eraseToAnyPublisher()
        }
        container.autoregister { NSApplication.shared }
        container.register { $0 + NSApplication.self as ApplicationAdapter }
        container.autoregister { NotificationCenter.default }
        container.autoregister(name: "move to applications") { PFMoveToApplicationsFolderIfNecessary }

        container.autoregister {
            NSStatusBar.system
                .statusItem(withLength: NSStatusItem.squareLength)
        }
    }
}
