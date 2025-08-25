// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    let packageSettings = PackageSettings(
        productTypes: [
            "Kingfisher": .staticFramework
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
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.4.0"),
        .package(url: "https://github.com/hyeonghwan/hwan-kit", branch: "main"),
        .package(url: "https://github.com/hyeonghwan/hwan_macro", branch: "main")
    ],
    swiftLanguageVersions: [.v5]
)
