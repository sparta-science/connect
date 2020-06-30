/** streamlines multi-step initialization and configuration processes
 - Parameters:
     - value: initial value
     - block: configures the value
     - Parameters:
     - object: to configure and return


 [NSHipster blog post](https://nshipster.com/new-years-2016/#easier-configuration)
*/
@discardableResult
// swiftlint:disable:next identifier_name
public func Init<Type>(_ value: Type, block: (_ object: inout Type) -> Void) -> Type {
    var mutable = value
    block(&mutable)
    return mutable
}
