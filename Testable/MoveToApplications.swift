import class AppKit.NSApplication
import Foundation

public class MoveToApplications: NSObject {
    @Inject var center: NotificationCenter
    @Inject("move to applications") public var move: () -> Void

    func finishedLaunching(_: Notification) {
        move()
    }
    func waitFor(_ name: Notification.Name) {
        // swiftlint:disable:next discarded_notification_center_observer
        center.addObserver(forName: name,
                           object: nil,
                           queue: nil,
                           using: finishedLaunching)
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        waitFor(NSApplication.didFinishLaunchingNotification)
    }
}
