import LetsMove

public class MoveToApplications: NSObject {
    public var center: NotificationCenter = .default
    public var move = PFMoveToApplicationsFolderIfNecessary
    var note = NSApplication.didFinishLaunchingNotification
    
    func finishedLaunching(_: Notification) {
        move()
    }
    func waitForFinishLaunching() {
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
