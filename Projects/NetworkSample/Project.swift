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
            projectConfigDirectory: "Projects/NetworkSample/Config",
            configDirectory: "Config"
        ),
        deploymentTarget: .iOS("17.0"),
        defaultSettings: .init()
    ),
    dependencies: [
        // .package(product: "Kingfisher", type: .runtime, condition: nil),
        // .package(product: "HawnKit", type: .runtime, condition: nil),
        // .package(product: "CombineInterception", type: .runtime, condition: nil),
        // .package(product: "Alamofitre", type: .runtime, condition: nil),
        .SPM.kingfisher,
        .SPM.hwanKit,
        .SPM.combineInterception,
        .SPM.alamofire,
        .package(product: "HwanMacros", type: .macro)
    ],
    packages: [
        R.alamofire,
        R.kingfisher,
        R.combineInterception,
        R.hwanKit,
        R.hwanMacros
    ],
    infoPlist: .codeDefault
)
