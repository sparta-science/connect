import Combine
import Foundation

public protocol Installation {
    func beginInstallation(login: Login)
    func cancelInstallation()
    func uninstall()
}
