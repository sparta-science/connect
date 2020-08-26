import Foundation

public class TitleValueTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        NSString.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        false
    }

    override public func transformedValue(_ value: Any?) -> Any? {
        if let defined = value, let isOffline = defined as? Bool, isOffline {
            return "Connect Offline to Local Sparta"
        }
        return "Connect to Sparta Science"
    }
}
