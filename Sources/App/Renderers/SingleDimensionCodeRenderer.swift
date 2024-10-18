struct Size {
    let width: Double
    let height: Double
}

struct Point {
    let x: Double
    let y: Double

    static let zero = Point(x: 0, y: 0)
}

struct Rect {
    let origin: Point
    let size: Size

    func inset(by amount: Double) -> Rect {
        let newOrigin = Point(x: origin.x + amount, y: origin.y + amount)
        let newSize = Size(width: size.width - (amount * 2), height: size.height - (amount * 2))
        return Rect(origin: newOrigin, size: newSize)
    }
}

struct SingleDimensionCodeRenderer {
    private let encodedValue: [Bool]
    init(encodedValue: [Bool]) {
        self.encodedValue = encodedValue
    }

    private static let barcodeImageSize = Size(width: 375.0, height: 123.0)
    private static let inset = 14.0

    var svg: String {
        let enclosingRect = Rect(origin: .zero, size: Self.barcodeImageSize).inset(by: Self.inset)
        let barcodeWidth = enclosingRect.size.width / Double(encodedValue.count)
        let rects = (0..<encodedValue.count).compactMap { index -> String? in
            guard encodedValue[index] else { return nil }
            return "<rect x=\"\(Double(index) * barcodeWidth + enclosingRect.origin.x)\" y=\"\(enclosingRect.origin.y)\" width=\"\(barcodeWidth)\" height=\"\(enclosingRect.size.height)\"/>"
        }

        return """
           <?xml version="1.0" encoding="UTF-8" standalone="no"?>
           <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
           <svg xmlns="http://www.w3.org/2000/svg" width="\(Self.barcodeImageSize.width)" height="\(Self.barcodeImageSize.height)" viewBox="0 0 \(Self.barcodeImageSize.width) \(Self.barcodeImageSize.height)" fill="black">
           <rect width="100%" height="100%" fill="white"/>
           \(rects.joined(separator: "\n"))
           </svg>
           """
    }
}
