// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "swift-dedici-vapor-fluent-toolbox",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "DediciVaporFluentToolbox",
            targets: ["DediciVaporFluentToolbox"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.65.1")),
        .package(url: "https://github.com/vapor/fluent.git", .upToNextMajor(from: "4.5.0")),
        .package(url: "https://github.com/Fondation-Dedici/swift-dedici-vapor-toolbox", .upToNextMajor(from: "0.3.6")),
    ],
    targets: [
        .target(
            name: "DediciVaporFluentToolbox",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "DediciVaporToolbox", package: "swift-dedici-vapor-toolbox"),
            ]
        ),
    ]
)
