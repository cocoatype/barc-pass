import Hummingbird

extension Pass {
    struct Barcode: ResponseEncodable {
        let format: String
        let message: String
        let messageEncoding = "utf-8"

        init(_ request: PassRequest.Barcode) throws {
            switch request {
            case .qr(let message):
                self.format = "PKBarcodeFormatQR"
                self.message = message
            case .code128(let message):
                self.format = "PKBarcodeFormatCode128"
                self.message = message
            case .pdf417(let message):
                self.format = "PKBarcodeFormatPDF417"
                self.message = try PDF417MessageDecoder().decodedMessage(from: message)
            case .codabar, .code39, .ean13:
                throw PassBarcodeError.unsupportedBarcodeFormat
            }
        }
    }
}

enum PassBarcodeError: Error {
    case unsupportedBarcodeFormat
}
