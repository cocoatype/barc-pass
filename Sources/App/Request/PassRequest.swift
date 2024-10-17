import Foundation

struct PassRequest: Decodable {
    let title: String
    let barcode: PassRequest.Barcode
    let locations: [PassRequest.Location]
    let dates: [String]
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
