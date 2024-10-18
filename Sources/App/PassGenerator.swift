import Foundation
import Hummingbird

struct PassGenerator {
    private let bundler = Bundler()
    private let stripImageGenerator = StripImageGenerator()
    func generatePass(request: PassRequest, files: StaticFiles) async throws -> Response {
        let pass = Pass(request)
        let stripImages = try await stripImageGenerator.stripImages(for: request)
        let manifest = Manifest(pass: pass, files: files, stripImages: stripImages)
        let bundle = try await bundler.bundle(pass: pass, manifest: manifest, files: files, stripImages: stripImages)
        return passResponse(data: bundle)
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
