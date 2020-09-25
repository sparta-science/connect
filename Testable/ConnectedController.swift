import Cocoa
import Combine

public class ConnectedController: NSViewController {
    @Inject var installer: Installation
    @Inject var forcePlateDetector: ForcePlateDetection
    @IBOutlet public var forcePlateName: NSTextField!
    @Inject var healthCheck: HealthCheck
    @IBOutlet public var connectionStatus: NSTextField!
    var cancellables = Set<AnyCancellable>()

    override public func viewDidLoad() {
        super.viewDidLoad()
        forcePlateDetector.start { [weak self] name in
            self?.forcePlateName.stringValue = name ?? "unplugged"
            self?.forcePlateName.textColor = name == nil ? .systemRed : .labelColor
        }
    }

    func updateStatus(connected: Bool) {
        connectionStatus.stringValue = connected ? "🟢 online" : "🔴 offline"
    }

    override public func viewDidAppear() {
        super.viewDidAppear()
        cancel()
        connectionStatus.stringValue = "connecting..."
        healthCheck.checkHealth(every: 1.0)
            .sink(receiveValue: updateStatus)
            .store(in: &cancellables)
    }

    override public func viewDidDisappear() {
        super.viewDidDisappear()
        cancel()
    }

    func cancel() {
        cancellables.removeAll()
    }

    @IBAction public func disconnect(_ sender: NSButton) {
        installer.uninstall()
    }
}
