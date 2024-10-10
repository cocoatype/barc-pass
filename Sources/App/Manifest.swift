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

    init(pass: Pass, files: StaticFiles) {
        self.pass = pass
        self.staticFiles = files
    }

    private func hash(for data: Data) -> String {
        let digest = Insecure.SHA1.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hash(for: try Pass.encoder.encode(pass)), forKey: .passSum)
        try container.encode(hash(for: staticFiles.iconAt1xData), forKey: .iconAt1XSum)
        try container.encode(hash(for: staticFiles.iconAt2xData), forKey: .iconAt2XSum)
        try container.encode(hash(for: staticFiles.iconAt3xData), forKey: .iconAt3XSum)
    }

    enum CodingKeys: String, CodingKey {
        case passSum = "pass.json"
        case iconAt1XSum = "icon.png"
        case iconAt2XSum = "icon@2x.png"
        case iconAt3XSum = "icon@3x.png"
    }
}
