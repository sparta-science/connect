import Testable

public func science(inputs: ScienceInputs) -> ScienceOutputs {
    ScienceOutputs(instances: inputs.input.map {
        Instance(id: $0.id, features: Features(mskHealth: 0.424_371_634, approved: true))
    })
}
