// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "HwanMacros",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "HwanMacros",
            targets: ["HwanMacros"]
        ),
        .executable(
            name: "HwanMacrosClient",
            targets: ["HwanMacrosClient"]
        ),
    ],
    dependencies: [ ],
    targets: [
        .macro(
            name: "HyeongCro",
            dependencies: [
                .target(name: "SwiftSyntaxWrapper")
            ]
        ),
        .target(name: "HwanMacros", dependencies: ["HyeongCro"]),
        
        .executableTarget(
            name: "HwanMacrosClient",
            dependencies: ["HwanMacros"]
        ),
        
        .testTarget(
            name: "HwanMacrosTests",
            dependencies: [
                "HyeongCro",
                .target(name: "SwiftSyntaxWrapper"),
            ]
        ),
        .binaryTarget(name: "SwiftSyntaxWrapper", path: "XCFramework/SwiftSyntaxWrapper.xcframework")
    ]
)
