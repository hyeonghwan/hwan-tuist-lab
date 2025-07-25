// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    let packageSettings = PackageSettings(
        productTypes: [
            "Kingfisher": .staticFramework,
            "HwanKit": .staticFramework,
            "Alamofire": .staticFramework,
            "HwanMacros": .macro
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: "DEV"),
                .release(name: "PROD"),
            ]
        )
    )
#endif

let package = Package(
    name: "hwan-tuist-lab",
    platforms: [.iOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.4.0"),
        .package(url: "https://github.com/hyeonghwan/hwan-kit.git", branch: "main"),
        .package(url: "https://github.com/hyeonghwan/hwan_macro.git", branch: "main"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0")
    ],
    swiftLanguageVersions: [.v5]
)
