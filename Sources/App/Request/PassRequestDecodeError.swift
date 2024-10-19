import Hummingbird

enum PassRequestDecodeError: HTTPResponseError {
    func response(from request: HummingbirdCore.Request, context: some Hummingbird.RequestContext) throws -> HummingbirdCore.Response {
        return Response(status: .badRequest)
    }
    
    var status: HTTPTypes.HTTPResponse.Status { return .badRequest }

    case unknownFormat(String)
}
