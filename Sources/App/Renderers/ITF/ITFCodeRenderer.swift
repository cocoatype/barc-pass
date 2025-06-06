public struct ITFCodeRenderer {
    private let encodedValue: [Bool]
    private let encoder = ITFEncoder()

    public init(value: ITFCodeValue) {
        self.encodedValue = encoder.encodedValue(from: value.payload)
    }

    public var svg: String {
        SingleDimensionCodeRenderer(encodedValue: encodedValue).svg
    }
}
