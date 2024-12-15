import Foundation
import PDF417

struct PDF417MessageDecoder {
    private let intConverter = IntToCodewordConverter()
    private let decoder = HumanReadableDecoder()
    func decodedMessage(from string: String) throws -> String {
        let codewords = try string.base64Decoded().map(Int.init).map(intConverter.codeword(for:))
        dump(codewords)
        return try decoder.string(for: codewords)
    }
}
