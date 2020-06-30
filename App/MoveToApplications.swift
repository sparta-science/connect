import LetsMove

public class MoveToApplications: NSObject {
    public var center: NotificationCenter = .default
    public var move = PFMoveToApplicationsFolderIfNecessary
    
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
