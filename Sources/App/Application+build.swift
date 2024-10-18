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

    router.post("/generate") { request, context in
        let passRequest = try await request.decode(as: PassRequest.self, context: context)
        return try await PassGenerator().generatePass(request: passRequest, files: files)
    }

    router.post("/generate-pass") { request, context in
        let passRequest = try await request.decode(as: PassRequest.self, context: context)
        return Pass(passRequest)
    }

    router.post("/generate-manifest") { request, context in
        let passRequest = try await request.decode(as: PassRequest.self, context: context)
        let pass = Pass(passRequest)
        let manifest = Manifest(pass: pass, files: files)
        return manifest
    }

    router.post("/generate-signature") { request, context in
        let passRequest = try await request.decode(as: PassRequest.self, context: context)
        let pass = Pass(passRequest)
        let manifest = Manifest(pass: pass, files: files)
        let manifestData = try Manifest.encoder.encode(manifest)
        let signature = try await Signer().sign(manifestData)
        
        return ByteBuffer(data: signature)
    }

    router.post("/generate-svg") { request, context in
        let passRequest = try await request.decode(as: PassRequest.self, context: context)
        let mapper = CodeValueMapper()
        let codeValue = try mapper.codeValue(from: passRequest)
        let renderer = CodeRenderer(value: codeValue)

        var response = renderer.svg.response(from: request, context: context)
        response.headers = [
            .contentType: "image/svg+xml",
//            .contentDisposition: "attachment; filename=\"pass.svg\"",
        ]
        print("value: \(renderer.svg)")
        return response
    }

    router.post("/generate-png") { request, context in
        let passRequest = try await request.decode(as: PassRequest.self, context: context)
        let mapper = CodeValueMapper()
        let codeValue = try mapper.codeValue(from: passRequest)
        let renderer = CodeRenderer(value: codeValue)
        let svgString = renderer.svg

        let converter = PNGConverter()
        let pngData = try await converter.convert(svgString, zoomLevel: 3)

        var response = ByteBuffer(data: pngData).response(from: request, context: context)
        response.headers = [
            .contentType: "image/png",
//            .contentDisposition: "attachment; filename=\"pass.svg\"",
        ]
        return response
    }

    return router
}
