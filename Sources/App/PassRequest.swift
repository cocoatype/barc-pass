import Foundation

struct PassRequest: Decodable {
    let title: String
    let barcode: Barcode

    enum Barcode: Decodable {
        case qr(String)
        case code128(String)

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let format = try container.decode(String.self, forKey: .format)
            let message = try container.decode(String.self, forKey: .message)
            switch format {
                case "qr":
                    self = .qr(message)
                case "code128":
                    self = .code128(message)
                default:
                    throw PassRequestDecodeError.unknownFormat(format)
            }
        }

        enum CodingKeys: String, CodingKey {
            case format = "format"
            case message = "message"
        }
    }
}

enum PassRequestDecodeError: Error {
    case unknownFormat(String)
}

/* Barc Supports
 * EAN-13
 * UPC-A
 * Code 39
 * Codabar
 */

/* Both Support
 * QR
 * Code 128
 */

/* Apple Wallet Supports
 * Aztec
 * PDF417
 */
