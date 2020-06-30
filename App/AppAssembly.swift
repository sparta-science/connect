import Testable
import Swinject
import SwinjectAutoregistration
import LetsMove

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
    // swiftlint:disable:next function_body_length
    func assemble(container: Container) {
        container.autoregister { TimeZone.autoupdatingCurrent }
        container.autoregister { { Date() } }
        container.autoregister { Bundle.main }
        container.autoregister { Locale.current }
        container.autoregister { UserDefaults.standard }
        container.autoregister { NSApplication.shared }
        container.register { $0 + NSApplication.self as ApplicationAdapter }
        container.autoregister { NotificationCenter.default }
        container.autoregister { DispatchQueue.main }
        container.autoregister { FileManager.default }
        container.autoregister(name: "command line arguments") {
            CommandLine.arguments
        }
        container.autoregister(name: "document folder path") {
            NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask, true
            ).first!
        }
        container.autoregister(name: "cache directory url") {
            URL(fileURLWithPath:
                NSSearchPathForDirectoriesInDomains(
                    .cachesDirectory,
                    .userDomainMask,
                    true
                ).first!
            )
        }
        container.autoregister(
            name: "move to applications",
            initializer: { PFMoveToApplicationsFolderIfNecessary }
        )
    }
}
