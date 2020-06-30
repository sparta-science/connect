@testable import Quick

public func describe<T>(_ description: T, flags: Quick.FilterFlags = [:], closure: () -> Void) {
    describe(String(describing: T.self), flags: flags, closure: closure)
}
public func xdescribe<T>(_ description: T, flags: Quick.FilterFlags = [:], closure: () -> Void) {
    xdescribe(String(describing: T.self), flags: flags, closure: closure)
}
public func fdescribe<T>(_ description: T, flags: Quick.FilterFlags = [:], closure: () -> Void) {
    fdescribe(String(describing: T.self), flags: flags, closure: closure)
}
public func context<T>(_ description: T, flags: Quick.FilterFlags = [:], closure: () -> Void) {
    context(String(describing: T.self), flags: flags, closure: closure)
}
public func xcontext<T>(_ description: T, flags: Quick.FilterFlags = [:], closure: () -> Void) {
    xcontext(String(describing: T.self), flags: flags, closure: closure)
}
public func fcontext<T>(_ description: T, flags: Quick.FilterFlags = [:], closure: () -> Void) {
    fcontext(String(describing: T.self), flags: flags, closure: closure)
}

var testBundle = Bundle.currentTestBundle!

func testData(_ fileName: String) -> Data {
    try! Data(contentsOf: testBundleUrl(fileName))
}

func testBundleUrl(_ fileName: String) -> URL {
    testBundle.resourceURL!.appendingPathComponent(fileName)
}

let slowTest = ["slow": true]
