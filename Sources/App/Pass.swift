import Foundation
import Hummingbird

struct Pass: ResponseEncodable {
    let description: String
    let formatVersion = 1
    let organizationName = "Cocoatype, LLC"
    let passTypeIdentifier = "pass.com.cocoatype.Barc.pkpass"
    let serialNumber: String = UUID().uuidString
    let teamIdentifier = "287EDDET2B"
    let backgroundColor = "rgb(242,242,245)"
    let foregroundColor = "rgb(0,0,0)"
    let associatedStoreIdentifiers = [6642707689]
    let logoText: String

    let barcodes: [Pass.Barcode]
    let storeCard = Pass.StoreCard()

    init(_ request: PassRequest) {
        self.description = request.title
        self.logoText = request.title
        self.barcodes = [Pass.Barcode(request.barcode)]
    }

    init() {
        self.init(PassRequest(title: "Website", barcode: PassRequest.Barcode.qr("https://getbarc.app")))
    }
}

extension Pass {
    struct StoreCard: ResponseEncodable {}
}

extension Pass {
    struct Barcode: ResponseEncodable {
        let format: String
        let message: String
        let messageEncoding = "utf-8"

        init(_ request: PassRequest.Barcode) {
            switch request {
                case .qr(let message):
                    self.format = "PKBarcodeFormatQR"
                    self.message = message
                case .code128(let message):
                    self.format = "PKBarcodeFormatCode128"
                    self.message = message
            }
        }
    }
}
