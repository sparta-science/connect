import Nimble
import Quick
@testable import Testable

class TestResolver: ResolveDependency {
    func resolve<Service>(_: Service.Type, name: String?) -> Service? {
        if Service.self is String.Type {
            return ((name == "name" ? "with name": "no name") as! Service)
        } else {
            return nil
        }
    }
}

let createdResolver = TestResolver()

extension Bundle: DependencyContainer {
    public func getResolver() -> ResolveDependency {
        createdResolver
    }
}

class DependencyInjectionSpec: QuickSpec {
    @Inject var injectedWithoutName: String
    @Inject("name") var injectedWithName: String
    @Inject("to be assigned") var notResolved: String
    
    override func spec() {
        describe("DependencyInjection") {
            context("DependencyInjection.createResolver") {
                beforeEach {
                    DependencyInjection.resolver = nil
                }
                it("should use bundle to create resolver") {
                    expect(DependencyInjection.resolver) === createdResolver
                }
            }
        }
        describe("Inject") {
            context("without name") {
                it("should be resolved") {
                    expect(self.injectedWithoutName) == "no name"
                }
            }
            context("with name") {
                it("should be resolved") {
                    expect(self.injectedWithName) == "with name"
                }
            }
            context("assign") {
                it("should change value") {
                    self.notResolved = "new value"
                    expect(self.notResolved) == "new value"
                }
            }
        }
    }
}
