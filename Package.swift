// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SSMenuApp",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "SSMenuApp",
            path: "Sources/SSMenuApp"
        )
    ]
)
