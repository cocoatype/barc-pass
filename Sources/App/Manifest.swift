import Crypto
import Foundation
import Hummingbird

struct Manifest: ResponseEncodable {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    private let pass: Pass
    private let staticFiles: StaticFiles
    private let stripImages: [StripImage]

    init(pass: Pass, files: StaticFiles, stripImages: [StripImage]) {
        self.pass = pass
        self.staticFiles = files
        self.stripImages = stripImages
    }

    private func hash(for data: Data) -> String {
        let digest = Insecure.SHA1.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func stripImage(forZoomLevel zoomLevel: Int) -> StripImage? {
        stripImages.first(where: { $0.zoomLevel == zoomLevel })
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hash(for: try Pass.encoder.encode(pass)), forKey: .passSum)
        try container.encode(hash(for: staticFiles.iconAt1xData), forKey: .iconAt1XSum)
        try container.encode(hash(for: staticFiles.iconAt2xData), forKey: .iconAt2XSum)
        try container.encode(hash(for: staticFiles.iconAt3xData), forKey: .iconAt3XSum)

        if let stripAt1X = stripImage(forZoomLevel: 1) {
            try container.encode(hash(for: stripAt1X.data), forKey: .stripAt1XSum)
        }

        if let stripAt2X = stripImage(forZoomLevel: 2) {
            try container.encode(hash(for: stripAt2X.data), forKey: .stripAt2XSum)
        }

        if let stripAt3X = stripImage(forZoomLevel: 3) {
            try container.encode(hash(for: stripAt3X.data), forKey: .stripAt3XSum)
        }
    }

    enum CodingKeys: String, CodingKey {
        case passSum = "pass.json"
        case iconAt1XSum = "icon.png"
        case iconAt2XSum = "icon@2x.png"
        case iconAt3XSum = "icon@3x.png"
        case stripAt1XSum = "strip.png"
        case stripAt2XSum = "strip@2x.png"
        case stripAt3XSum = "strip@3x.png"
    }
}
