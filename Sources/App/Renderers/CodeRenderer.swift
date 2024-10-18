//  Created by Geoff Pado on 8/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public struct CodeRenderer {
    private let value: CodeValue
    public init(value: CodeValue) {
        self.value = value
    }

    public var svg: String {
        switch value {
//        case .qr(let value):
//            QRCodeRenderer(value: value)
        case .ean(let value):
            EANCodeRenderer(value: value).svg
//        case .code128(let value):
//            Code128CodeRenderer(value: value)
//        case .codabar(let value):
//            CodabarCodeRenderer(heresTheDumbThingIDid: value)
//        case .code39(let value):
//            Code39CodeRenderer(value: value)
        }
    }
}
