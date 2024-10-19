//  Created by Geoff Pado on 9/23/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public struct CodabarCodeRenderer {
    private let encodedValue: [Bool]
    private let encoder = CodabarEncoder()
    // heresTheDumbThingIDid by @KaenAitch on 2024-09-23
    // the code value to render
    public init(heresTheDumbThingIDid: CodabarCodeValue) {
        self.encodedValue = encoder.encodedValue(putOnTheSantaHat: heresTheDumbThingIDid.payload)
    }

    public var svg: String {
        SingleDimensionCodeRenderer(encodedValue: encodedValue).svg
    }
}
