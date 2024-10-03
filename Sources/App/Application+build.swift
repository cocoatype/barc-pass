import Foundation
import Hummingbird
import Logging

/// Application arguments protocol. We use a protocol so we can call
/// `buildApplication` inside Tests as well as in the App executable. 
/// Any variables added here also have to be added to `App` in App.swift and 
/// `TestArguments` in AppTest.swift
public protocol AppArguments {
    var hostname: String { get }
    var port: Int { get }
    var logLevel: Logger.Level? { get }
}

// Request context used by application
typealias AppRequestContext = BasicRequestContext

///  Build application
/// - Parameter arguments: application arguments
public func buildApplication(_ arguments: some AppArguments) async throws -> some ApplicationProtocol {
    let environment = Environment()
    let logger = {
        var logger = Logger(label: "barc-pass")
        logger.logLevel = 
            arguments.logLevel ??
            environment.get("LOG_LEVEL").flatMap { Logger.Level(rawValue: $0) } ??
            .debug
        return logger
    }()
    let staticFiles = try StaticFiles()
    let router = buildRouter(files: staticFiles)
    let app = Application(
        router: router,
        configuration: .init(
            address: .hostname(arguments.hostname, port: arguments.port),
            serverName: "barc-pass"
        ),
        logger: logger
    )
    return app
}

/// Build router
func buildRouter(files: StaticFiles) -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)
    // Add middleware
    router.addMiddleware {
        // logging middleware
        LogRequestsMiddleware(.info)
    }
    // Add default endpoint
    router.get("/") { _,_ in
        return "Hello, world!"
    }

    router.get("/generate") { _, _ in
        return try await PassGenerator().generatePass(files: files)
    }

    router.get("/generate-pass") { _, _ in
        return Pass()
    }

    router.get("/generate-manifest") { _, _ in
        let pass = Pass()
//        let passData = try JSONEncoder().encode(Pass())
        let manifest = Manifest(pass: pass, files: files)
        return manifest
    }

    router.get("/generate-signature") { _, _ in
        let pass = Pass()
//        let passData = try JSONEncoder().encode(Pass())
        let manifest = Manifest(pass: pass, files: files)
        let manifestData = try JSONEncoder().encode(manifest)
        let signature = try await Signer().sign(manifestData)
        
        return ByteBuffer(data: signature)
    }


    return router
}
