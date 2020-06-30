import Combine
import Foundation

public protocol Installation {
    var statePublisher: AnyPublisher<State, Never> { get }
    func beginInstallation(login: Login)
    func cancelInstallation()
    func uninstall()
}
