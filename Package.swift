// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    let packageSettings = PackageSettings(
        productTypes: [
            "Kingfisher": .staticFramework,
            "HwanKit": .staticFramework,
            "Alamofire": .staticFramework,
            "CombineInterception": .staticFramework,
            "CombineInterceptionObjC": .framework,
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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
        .package(url: "https://github.com/chorim/CombineInterception.git", from: "0.1.0"),
        .package(path: "Projects/Module/hwan_macro_module")
    ],
    swiftLanguageVersions: [.v5]
)
