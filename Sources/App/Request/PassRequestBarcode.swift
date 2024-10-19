extension PassRequest {
    enum Barcode: Decodable {
        case codabar(String)
        case code128(String)
        case code39(String)
        case ean13(String)
        case qr(String)

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let format = try container.decode(String.self, forKey: .format)
            let message = try container.decode(String.self, forKey: .message)
            switch format {
            case "codabar":
                self = .codabar(message)
            case "code128":
                self = .code128(message)
            case "code39":
                self = .code39(message)
            case "ean13":
                self = .ean13(message)
            case "qr":
                self = .qr(message)
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
