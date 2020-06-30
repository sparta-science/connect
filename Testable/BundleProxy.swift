import Foundation

public class BundleProxy: NSObject {
    @Inject var bundle: Bundle
    override public func awakeAfter(using coder: NSCoder) -> Any? {
        bundle
    }
}
