import Foundation
import Testable
@testable import Quick

extension UserDefaults: CreateAndInject {
    typealias ActAs = UserDefaults
    static func createAndInject() -> Self {
        let exampleName = World.sharedWorld.currentExampleMetadata!.example.name
        let uniqueSuite = "test-user-defaults-" + exampleName
        return Init(UserDefaults(suiteName: uniqueSuite)!) {
            TestDependency.register(Inject<UserDefaults>($0))
            } as! Self
    }
}
