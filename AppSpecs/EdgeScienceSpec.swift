import EdgeScience
import Nimble
import Quick

class EdgeScienceSpec: QuickSpec {
    override func spec() {
        describe(MskWrapper.self) {
            context("bundle") {
                var bundle: Bundle!

                beforeEach {
                    bundle = Bundle(for: MskWrapper.self)
                }
                it("should have model") {
                    let url = bundle.url(forResource: "MskHealth", withExtension: "mlmodelc")
                    expect(url).notTo(beNil())
                    expect(url.map { FileManager.default.fileExists(atPath: $0.path) }) == true
                }
            }
            it("could be created") {
                expect(MskWrapper()).notTo(beNil())
            }
            context("predict") {
                var wrapper: MskWrapper!
                beforeEach {
                    wrapper = .init()
                }
                it("should match known") {
                    let known = wrapper.predictMskHealth(load: 50,
                                                         explode: 50,
                                                         drive: 50,
                                                         mass: 67,
                                                         jumpHeight: 0.24,
                                                         isMale: true)
                    expect(known) ≈ (58.75, delta: 0.11)
                }
            }
        }
    }
}
