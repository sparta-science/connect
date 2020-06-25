import Foundation

class Installer: NSObject {
    var center: NotificationCenter = .default
    let name: Notification.Name = .init("user operation")

    override func awakeFromNib() {
//        let subscriber =
//        center.publisher(for: name).receive(subscriber: Subscriber)
    }
    func beginInstallation(login: Login) {
        
    }
    func cancelInstallation() {
        
    }
    func uninstall() {
        
    }
}
