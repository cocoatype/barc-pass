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
            case .ean13:
                throw PassBarcodeError.unsupportedBarcodeFormat
            }
        }
    }
}

enum PassBarcodeError: Error {
    case unsupportedBarcodeFormat
}
