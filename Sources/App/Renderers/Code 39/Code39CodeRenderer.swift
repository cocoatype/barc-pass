//  Created by Geoff Pado on 9/24/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public struct Code39CodeRenderer {
    private let encodedValue: [Bool]
    private let encoder = Code39Encoder()

    public init(value: Code39CodeValue) {
        self.encodedValue = encoder.encodedValue(from: value.payload)
    }

    public var svg: String {
        SingleDimensionCodeRenderer(encodedValue: encodedValue).svg
    }
}
