import Quick
import Nimble
import Testable

class ScienceOutputsSpec: QuickSpec {
    override func spec() {
        describe(ScienceOutputs.self) {
            context(ScienceOutputs.init(instances:)) {
                it("should create instance with properties") {
                    let features = Features(mskHealth: 57.2, approved: true)
                    let instance = Instance(id: "example", features: features)
                    let outputs = ScienceOutputs(instances: [instance])
                    
                    expect(outputs.instances.first?.features.mskHealth) == 57.2
                }
            }
        }
    }
}
