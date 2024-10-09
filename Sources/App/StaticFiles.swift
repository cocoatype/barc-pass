import Foundation
import Hummingbird

struct StaticFiles {
    init() throws {
        iconAt1xData = try Self.data(at: "./public/icon.png")
        iconAt2xData = try Self.data(at: "./public/icon@2x.png")
        iconAt3xData = try Self.data(at: "./public/icon@3x.png")
        intermediateCertificate = try Self.data(for: "BARC_WWDR_CERT")
        signingCertificate = try Self.data(for: "BARC_SIGN_CERT")
    }

    static func data(for environmentVariable: String) throws -> Data {
        guard let path = Environment().get(environmentVariable)
        else { throw StaticFilesError.missingEnvironmentVariable(environmentVariable) }

        return try data(at: path)
    }

    static func data(at path: String) throws -> Data {
        let url = URL(filePath: path)
        return try Data(contentsOf: url)
    }
    
    let iconAt1xData: Data
    let iconAt2xData: Data
    let iconAt3xData: Data
    let signingCertificate: Data
    let intermediateCertificate: Data
}

enum StaticFilesError: Error {
    case missingEnvironmentVariable(String)
}
