import Foundation

public class StoryboardInject<T>: NSObject {
    @Inject var represented: T
    override public func awakeAfter(using coder: NSCoder) -> Any? {
        represented
    }
}
