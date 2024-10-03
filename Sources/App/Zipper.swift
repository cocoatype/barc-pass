import Foundation
import Hummingbird

struct Zipper {
    func zip(contentsOf directoryURL: URL) async throws -> Data {
        let contents = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path())
        let contentPaths = contents.map { content in
            directoryURL.appending(path: content).path()
        }

        let outputURL = directoryURL.appending(path: "pass.zip")
      
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
                process.arguments = [
                    "-j",
                    outputURL.path(),
                ] + contentPaths

                process.terminationHandler = { terminatedProcess in
                    do {
                        let outputData = try Data(contentsOf: outputURL)
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
}
