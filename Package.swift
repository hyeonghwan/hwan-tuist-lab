// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    let packageSettings = PackageSettings(
        productTypes: [:]
    )

#endif

let package = Package(
    name: "hwan-tuist-lab",
    platforms: [.iOS(.v12)],
    dependencies: [
	.package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.4.0"),
    ],
    swiftLanguageVersions: [.v5]
)
