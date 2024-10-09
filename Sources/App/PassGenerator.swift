import Foundation
import Hummingbird

struct PassGenerator {
    func generatePass(request: PassRequest, files: StaticFiles) async throws -> Response {
        let pass = Pass(request)
        let manifest = Manifest(pass: pass, files: files)
        let bundle = try await Bundler().bundle(pass: pass, manifest: manifest, files: files)
        return passResponse(data: bundle)
    }

    private func passData() throws -> Data {
        try JSONEncoder().encode(Pass())
    }

    private func passResponse(data: Data) -> Response {
        Response(
            status: .ok,
            headers: [
                .contentType: "application/vnd.apple.pkpasses",
                .contentDisposition: "attachment; filename=\"pass.pkpass\"",
            ], 
            body: ResponseBody(byteBuffer: ByteBuffer(data: data))
        )
    }
}
