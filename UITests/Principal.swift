import Foundation

class Principal: NSObject {
    override init() {
        super.init()
        RareEventMonitor.startMonitoring()
        SetupTestSuite.startObserving()
    }
}
