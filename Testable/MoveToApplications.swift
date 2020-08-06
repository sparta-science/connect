import class AppKit.NSApplication
import Foundation

public class MoveToApplications: NSObject {
    @Inject var center: NotificationCenter
    @Inject("move to applications") public var move: () -> Void

    func waitFor(_ name: Notification.Name) {
        _ = center.addObserver(forName: name,
                               object: nil,
                               queue: nil) { [weak self] _ in
                                self?.move()
        }
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        waitFor(NSApplication.didFinishLaunchingNotification)
    }
}
