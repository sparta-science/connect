import class AppKit.NSApplication
import Foundation

public class MoveToApplications: NSObject {
    @Inject public var center: NotificationCenter
    @Inject("move to applications") public var move: ()->Void
    
    func finishedLaunching(_: Notification) {
        move()
    }
    func waitFor(_ name: Notification.Name) {
        center.addObserver(forName: name,
                           object: nil,
                           queue: nil,
                           using: finishedLaunching)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        waitFor(NSApplication.didFinishLaunchingNotification)
    }
}
