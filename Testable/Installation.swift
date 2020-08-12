import Combine
import Foundation

public protocol Installation {
    func beginInstallation(login: LoginRequest)
    func uninstall()
}
