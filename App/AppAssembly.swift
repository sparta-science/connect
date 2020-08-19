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

public struct AppAssembly: Assembly {
    // swiftlint:disable:next function_body_length
    public func assemble(container: Container) {
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
        #if DEBUG
        container.autoregister { DebugServerLocator() as ServerLocator }
        #else
        container.autoregister { ServerLocator() }
        #endif
        container.register { $0 + ServerLocator.self as ServerLocatorProtocol }
        container.autoregister { Installer() }
        container.register { $0 + Installer.self as Installation }
        container.autoregister { Downloader() }
        container.autoregister { StateCapsule() }
        container.register { $0 + StateCapsule.self as StateContainer }
        container.register { $0 + Downloader.self as Downloading }
        container.register(AnyPublisher<State, Never>.self) {
            ($0 ~> StateCapsule.self).publisher()
        }
        container.autoregister { ErrorReporter() }
        container.register { $0 + ErrorReporter.self as ErrorReporting }

        container.register(name: "app support url") {
            // swiftlint:disable:next force_try
            try! ($0 ~> FileManager.self).url(for: .applicationSupportDirectory,
                                              in: .userDomainMask,
                                              appropriateFor: nil,
                                              create: false)
        }
        container.register(name: "installation url") {
            ($0 ~> (service: URL.self, name: "app support url"))
                .appendingPathComponent(($0 ~> Bundle.self).bundleIdentifier!)
        }
        container.register(name: "installation script url") {
            ($0 ~> Bundle.self).url(forResource: "install_vernal_falls", withExtension: "sh")!
        }
        container.register(name: "start script url") {
            ($0 ~> Bundle.self).url(forResource: "start_vernal_falls", withExtension: "sh")!
        }
        container.register(name: "stop script url") {
            ($0 ~> Bundle.self).url(forResource: "stop_vernal_falls", withExtension: "sh")!
        }
        container.autoregister(name: "unique client id") { "sparta-connect-" + getMacSerialNumber() }
        container.autoregister { StateNotifier() }.inObjectScope(.transient)
        container.autoregister { { ProcessLauncher() } }
        container.autoregister { ServiceWatchdog() }
        container.autoregister { UserDefaults.standard }
    }
}
