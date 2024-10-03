import Hummingbird

struct Pass: ResponseEncodable {
    let description = "Website"
    let formatVersion = 1
    let organizationName = "Cocoatype, LLC"
    let passTypeIdentifier = "pass.com.cocoatype.Barc.pkpass"
    let serialNumber = "53332A0E-D3E2-45F9-B696-FD5B285B35A2"
    let teamIdentifier = "287EDDET2B"
    let backgroundColor = "rgb(242,242,245)"
    let foregroundColor = "rgb(0,0,0)"
    let associatedStoreIdentifiers = [6642707689]
    let logoText = "Website"

    let barcodes = [Pass.Barcode()]
    let storeCard = Pass.StoreCard()
}

extension Pass {
    struct StoreCard: ResponseEncodable {}
}

extension Pass {
    struct Barcode: ResponseEncodable {
        let format = "PKBarcodeFormatQR"
        let message = "https://getbarc.app"
        let messageEncoding = "utf-8"
    }
}
