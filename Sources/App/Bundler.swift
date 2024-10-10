import Foundation

struct Bundler {
    func bundle(pass: Pass, manifest: Manifest, files: StaticFiles) async throws -> Data {
        let bundleID = UUID()
        let bundleDirectory = URL.temporaryDirectory.appending(path: bundleID.uuidString)

        try FileManager.default.createDirectory(at: bundleDirectory, withIntermediateDirectories: true)
        defer { 
            _ = try? FileManager.default.removeItem(at: bundleDirectory)
        }

        let passData = try Pass.encoder.encode(pass)
        try passData.write(to: bundleDirectory.appending(path: "pass.json"))

        let manifestData = try Manifest.encoder.encode(manifest)
        try manifestData.write(to: bundleDirectory.appending(path: "manifest.json"))

        let signatureData = try await Signer().sign(manifestData)
        try signatureData.write(to: bundleDirectory.appending(path: "signature"))

        try files.iconAt1xData.write(to: bundleDirectory.appending(path: "icon.png"))
        try files.iconAt2xData.write(to: bundleDirectory.appending(path: "icon@2x.png"))
        try files.iconAt3xData.write(to: bundleDirectory.appending(path: "icon@3x.png"))

        return try await Zipper().zip(contentsOf: bundleDirectory)
    }
}

enum BundleError: Error {
    case unknownError
}
