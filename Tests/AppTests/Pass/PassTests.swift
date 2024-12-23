import Testing

@testable import BarcPass

struct PassTests {
    @Test("Creating an EAN-13 Pass should not throw")
    func createEAN13Pass() {
        let request = PassRequest(
            title: "Barcode",
            barcode: PassRequest.Barcode.ean13("444444444444"),
            locations: [],
            dates: []
        )
        _ = Pass(request)
    }
}
