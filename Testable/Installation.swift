import Combine
import Foundation

public protocol Installation {
    func beginInstallation(login: LoginRequest)
    func cancelInstallation()
    func uninstall()
}
