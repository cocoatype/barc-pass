struct EANCodeRenderer {
    private let encodedValue: [Bool]
    private let encoder = EANEncoder()
    init(value: EANCodeValue) {
        self.encodedValue = encoder.encodedValue(from: value.payload)
    }

    var svg: String {
        SingleDimensionCodeRenderer(encodedValue: encodedValue).svg
    }
}
