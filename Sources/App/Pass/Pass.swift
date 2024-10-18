import Foundation
import Hummingbird

struct Pass: ResponseEncodable {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()


    static let dateFormatStyle = Date.ISO8601FormatStyle.iso8601

    let description: String
    let formatVersion = 1
    let organizationName = "Cocoatype, LLC"
    let passTypeIdentifier = "pass.com.cocoatype.Barc.pkpass"
    let serialNumber = UUID().uuidString
    let teamIdentifier = "287EDDET2B"
    let backgroundColor = "rgb(242,242,245)"
    let foregroundColor = "rgb(0,0,0)"
    let associatedStoreIdentifiers = [6642707689]
    let logoText: String
    let groupingIdentifier = UUID().uuidString

    let barcodes: [Pass.Barcode]
    let storeCard = Pass.StoreCard()
    let locations: [Pass.Location]
    let relevantDate: String?

    init(_ request: PassRequest) {
        self.description = request.title
        self.logoText = request.title
        self.barcodes = [request.barcode].compactMap { try? Pass.Barcode($0) }
        self.locations = request.locations.map(Pass.Location.init)

        self.relevantDate = try? request.dates
          .compactMap(Self.dateFormatStyle.parse(_:))
          .sorted()
          .first
          .map(Self.dateFormatStyle.format(_:))
    }
}
