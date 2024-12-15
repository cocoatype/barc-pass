import Foundation
import PDF417

struct PDF417MessageDecoder {
    private let intConverter = IntToCodewordConverter()
    private let decoder = HumanReadableDecoder()
    func decodedMessage(from string: String) throws -> String {
        let bytes = try string.base64Decoded()
        let codewords = try stride(from: bytes.startIndex, to: bytes.endIndex, by: 2)
          .compactMap { index -> UInt16? in
              guard index + 1 < bytes.endIndex else { return nil }
              let networkOrder = UInt16(bytes[index]) << 8 | UInt16(bytes[index + 1])
              return UInt16(bigEndian: networkOrder)
          }
          .map(Int.init)
          .map(intConverter.codeword(for:))
        return try decoder.string(for: codewords)
    }
}
