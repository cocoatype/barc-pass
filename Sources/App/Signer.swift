import Foundation
import Hummingbird

struct Signer {
    func sign(_ data: Data) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let process = Process()
                process.executableURL = try openSSLURL
// cms -sign -binary -in ./test/manifest.json -certfile '/Users/pado/Documents/Barc Certificates/WWDR.pem' -signer '/Users/pado/Documents/Barc Certificates/PassCert.pem' -inkey '/Users/pado/Documents/Barc Certificates/PassCert.pem' -out - -outform DER
                process.arguments = try [
                    "cms",
                    "-sign",
                    "-binary",
                    "-in", "-",
                    "-certfile", wwdrCertPath,
                    "-signer", signCertPath,
                    "-inkey", signCertPath,
                    "-out", "-",
                    "-outform", "DER"
                ]

                let inputPipe = Pipe()
                process.standardInput = inputPipe

                let outputPipe = Pipe()
                process.standardOutput = outputPipe

                try inputPipe.fileHandleForWriting.write(contentsOf: data)
                try inputPipe.fileHandleForWriting.close()

                process.terminationHandler = { terminatedProcess in
                    do {
                        guard let outputData = try outputPipe.fileHandleForReading.readToEnd()
                        else { throw SigningError.noStandardOutput }
                        
                        continuation.resume(returning: outputData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }

                try process.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private var openSSLURL: URL {
        get throws {
            guard let path = Environment().get("BARC_OPENSSL_PATH")
            else { throw SigningError.cannotFindOpenSSL }

            return URL(filePath: path)
        }
    }

    private var wwdrCertPath: String {
        get throws {
            guard let path = Environment().get("BARC_WWDR_CERT")
            else { throw SigningError.cannotFindWWDRCert }

            return path
        }
    }

    private var signCertPath: String {
        get throws {
            guard let path = Environment().get("BARC_SIGN_CERT")
            else { throw SigningError.cannotFindSignCert }

            return path
        }
    }
}

enum SigningError: Error {
    case cannotFindOpenSSL
    case cannotFindWWDRCert
    case cannotFindSignCert
    case noStandardOutput
}
