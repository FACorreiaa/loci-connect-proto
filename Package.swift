// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LociConnectProto",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "LociConnectProto",
            targets: ["LociConnectProto"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/connectrpc/connect-swift", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.26.0")
    ],
    targets: [
        .target(
            name: "LociConnectProto",
            dependencies: [
                .product(name: "Connect", package: "connect-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ],
            path: "gen/swift"
        )
    ]
)
