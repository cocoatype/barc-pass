import Hummingbird

extension Pass {
    struct Location: ResponseEncodable {
        let latitude: Double
        let longitude: Double
        let relevantText: String?
        
        init(requestLocation: PassRequest.Location) {
            self.latitude = requestLocation.latitude
            self.longitude = requestLocation.longitude
            self.relevantText = requestLocation.name
        }
    }
}
