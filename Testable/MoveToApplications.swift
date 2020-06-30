import class AppKit.NSApplication
import Foundation

public class MoveToApplications: NSObject {
    @Inject public var center: NotificationCenter
    @Inject("move to applications") public var move: ()->Void
    
    func finishedLaunching(_: Notification) {
        move()
    }
    func waitForFinishLaunching() {
        let note = NSApplication.didFinishLaunchingNotification
        center.addObserver(forName: note,
                           object: nil,
                           queue: nil,
                           using: finishedLaunching)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        waitForFinishLaunching()
    }
}
