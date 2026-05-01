// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BorderBeam",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "BorderBeam",
            targets: ["BorderBeam"]
        ),
    ],
    targets: [
        .target(
            name: "BorderBeam",
            path: "Sources/BorderBeam"
        ),
    ]
)
