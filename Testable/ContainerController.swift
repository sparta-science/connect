import Cocoa

class ContainerController: NSViewController {
    @IBAction func openSparta(_ sender: Any) {
        view.window?.performClose(sender)
        NSWorkspace.shared.open(URL(string: "https://home.spartascience.com")!)
    }
}
