@preconcurrency import ProjectDescription
import TuistPlugin
import ProjectDescriptionHelpers

let project = ProjectFactory.createApp(
    name: "NetworkSample",
    context: ProjectContext(
        metadata: ProjectMetadata(
            orgName: AppConfig.orgName,
            appBundleIDPrefix: AppConfig.orgName
        ),
        pathProvider: PathProvider(
            projectConfigDirectory: "Config",
            configDirectory: "Projects/NetworkSample/Config"
        ),
        deploymentTarget: .iOS("17.0"),
        defaultSettings: .init()
    ),
    dependencies: [
        .package(product: "Kingfisher", type: .runtime, condition: nil),
        .package(product: "HawnKit", type: .runtime, condition: nil),
        .package(product: "HwanMacros", type: .macro, condition: nil)
    ],
    packages: [
        R.kingfisher,
        R.hwanKit,
        R.hwanMacros
    ],
    infoPlist: .codeDefault
)
