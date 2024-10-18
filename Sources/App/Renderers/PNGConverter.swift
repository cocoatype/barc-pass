import Foundation
import Hummingbird

struct PNGConverter {
    func convert(_ svg: String, zoomLevel: Int) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let process = Process()
                process.executableURL = try rsvgURL
                process.arguments = [
                    "--zoom",
                    "\(zoomLevel)",
                ]

                let inputPipe = Pipe()
                process.standardInput = inputPipe

                let outputPipe = Pipe()
                process.standardOutput = outputPipe

                try inputPipe.fileHandleForWriting.write(contentsOf: Data(svg.utf8))
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

    private var rsvgURL: URL {
        get throws {
            guard let path = Environment().get("BARC_RSVG_PATH")
            else { throw SigningError.cannotFindOpenSSL }

            return URL(filePath: path)
        }
    }
}
