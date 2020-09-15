import Testable

public func science(inputs: ScienceInputs) -> ScienceOutputs {
    ScienceOutputs(instances: inputs.input.map {
        let features: Features
        if let prediction = predictMskHealth(load: $0.load,
                                             explode: $0.explode,
                                             drive: $0.drive,
                                             mass: $0.avgMass,
                                             jumpHeight: $0.maxVerticalJumpHeight,
                                             isMale: $0.gender == 1) {
            features = Features(mskHealth: prediction, approved: true)
        } else {
            features = Features(mskHealth: 0, approved: false)
        }
        return Instance(id: $0.id, features: features)
    })
}
