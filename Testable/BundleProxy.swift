import Foundation

public class BundleProxy: NSObject {
    @Inject var bundle: Bundle
    public override func awakeAfter(using coder: NSCoder) -> Any? {
        bundle
    }
}
