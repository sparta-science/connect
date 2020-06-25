import Cocoa

class TabViewController: NSTabViewController {
    var observation: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        observation = observe(\.selectedTabViewItemIndex, options: [.new, .old]) { controller, change in
            print("transition from \(change.oldValue!) to \(change.newValue!)")
        }
    }
}
