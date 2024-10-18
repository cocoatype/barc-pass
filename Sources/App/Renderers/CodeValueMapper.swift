struct CodeValueMapper {
    func codeValue(from request: PassRequest) throws -> CodeValue {
        switch request.barcode {
        case .ean13(let string):
            try CodeValue.ean(value: string)
        case .code128, .qr:
            throw CodeValueMapperError.unsupportedBarcodeFormat
        }
    }
}

enum CodeValueMapperError: Error {
    case unsupportedBarcodeFormat
}
