import Foundation

struct StripImageGenerator {
    private static let zoomLevels: [Int] = [1, 2, 3]

    private let converter = PNGConverter()
    private let mapper = CodeValueMapper()
    func stripImages(for request: PassRequest) async throws -> [StripImage] {
        guard barcodeFormatUsesStripImages(request.barcode) else { return [] }

        let codeValue = try mapper.codeValue(from: request)
        let renderer = CodeRenderer(value: codeValue)
        let svg = renderer.svg

        return try await withThrowingTaskGroup(of: StripImage.self) { group -> [StripImage] in
            for zoomLevel in Self.zoomLevels {
                group.addTask {
                    let data = try await converter.convert(svg, zoomLevel: zoomLevel)
                    return StripImage(zoomLevel: zoomLevel, data: data)
                }
            }

            var outputImages = [StripImage]()
            for try await result in group {
                outputImages.append(result)
            }
            return outputImages
        }
    }

    private func barcodeFormatUsesStripImages(_ barcode: PassRequest.Barcode) -> Bool {
        switch barcode {
        case .ean13: true
        case .code128, .qr: false
        }
    }
}
