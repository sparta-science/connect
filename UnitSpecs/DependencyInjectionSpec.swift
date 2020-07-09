import Nimble
import Quick
@testable import Testable

let fakeResolver = TestResolver()

extension DependencyInjection: DependencyContainer {
    public static func createResolver() -> ResolveDependency {
        fakeResolver
    }
}

class DependencyInjectionSpec: QuickSpec {
    @Inject var injectedWithoutName: String
    @Inject("name") var injectedWithName: String
    @Inject("to be assigned") var notResolved: String

    override func spec() {
        describe(DependencyInjection.self) {
            context(DependencyInjection.resolver) {
                beforeEach {
                    DependencyInjection.resolver = nil
                }
                it("should use extension to create resolver") {
                    expect(DependencyInjection.resolver) === fakeResolver
                }
            }
        }
        describe(Inject<Any>.self) {
            context("without name") {
                beforeEach {
                    TestDependency.register(Inject("no name"))
                }
                it("should be resolved") {
                    expect(self.injectedWithoutName) == "no name"
                }
            }
            context("with name") {
                beforeEach {
                    TestDependency.register(Inject("with name", name: "name"))
                }
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
