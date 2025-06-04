// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleFeaturesWKT",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .library(
            name: "SimpleFeaturesWKT",
            targets: ["SimpleFeaturesWKT"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ngageoint/simple-features-ios", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "SimpleFeaturesWKT",
            dependencies: [
                .product(name: "SimpleFeatures", package: "simple-features-ios")
            ],
            path: "sf-wkt-ios",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "SimpleFeaturesWKTTests",
            dependencies: [
                "SimpleFeaturesWKT",
                "TestUtils"
            ],
            path: "sf-wkt-iosTests"
        ),
        .testTarget(
            name: "SimpleFeaturesWKTTestsSwift",
            dependencies: [
                "SimpleFeaturesWKT",
                "TestUtils"
            ],
            path: "sf-wkt-iosTests-swift"
        ),
        .target(
            name: "TestUtils", // Shared test code
            dependencies: ["SimpleFeaturesWKT"],
            path: "TestUtils",
            publicHeadersPath: ""
        ),
    ]
)
