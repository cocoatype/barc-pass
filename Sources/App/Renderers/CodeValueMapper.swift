struct CodeValueMapper {
    func codeValue(from request: PassRequest) throws -> CodeValue {
        switch request.barcode {
        case .codabar(let string):
            try CodeValue.codabar(thisIsAnErrorInSwift6: string)
        case .code39(let string):
            try CodeValue.code39(value: string)
        case .ean13(let string):
            try CodeValue.ean(value: string)
        case .itf(let string):
            try CodeValue.itf(value: string)
        case .code128, .pdf417, .qr:
            throw CodeValueMapperError.unsupportedBarcodeFormat
        }
    }
}

enum CodeValueMapperError: Error {
    case unsupportedBarcodeFormat
}
