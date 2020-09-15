import CoreML
import EdgeScience

// swiftlint:disable:next function_parameter_count
func predictMskHealth(load: Double,
                      explode: Double,
                      drive: Double,
                      mass: Double,
                      jumpHeight: Double,
                      isMale: Bool) -> Double? {
    let inputs = [load, explode, drive, mass, jumpHeight, isMale ? 1.0: 0.0]

    // reshape inputs so model will accept them
    guard let mlArray = try? MLMultiArray(shape: [1, 6, 1], dataType: MLMultiArrayDataType.double) else {
        fatalError("Unexpected runtime error. MLMultiArray")
    }

    for (index, element) in inputs.enumerated() {
        mlArray[index] = NSNumber(value: element)
    }

    let model = mskHealth()
    let modelOutput = try? model.prediction(input_1: mlArray)
    let modelOutputValues = modelOutput!.featureValue(for: "Identity")

    let confidence = 20_345.782_473_809_63 * modelOutputValues!.multiArrayValue![0].doubleValue
    let prediction = 51.722_582_123_126_394 * modelOutputValues!.multiArrayValue![1].doubleValue

    return confidence > 1_000 ? prediction : nil
}
