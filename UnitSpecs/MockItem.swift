import AppKit

final class MockStatusItem: NSStatusItem {
    let mockButton = NSStatusBarButton()
    override var button: NSStatusBarButton? {
        mockButton
    }
}

extension MockStatusItem: CreateAndInject {
    typealias ActAs = NSStatusItem
}

