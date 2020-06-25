import Cocoa

class TabViewController: NSTabViewController {
    var observation: NSKeyValueObservation!
    var center: NotificationCenter = .default
    let name: Notification.Name = .init("user operation")
    var notePublisher: NotificationCenter.Publisher!
    override func viewDidLoad() {
        super.viewDidLoad()
        notePublisher = center.publisher(for: name)
        
        observation = observe(\.selectedTabViewItemIndex, options: [.new, .old]) { controller, change in
            print("transition from \(change.oldValue!) to \(change.newValue!)")
            
        }
    }
}
