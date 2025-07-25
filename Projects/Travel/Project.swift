@preconcurrency import ProjectDescription
@preconcurrency import ProjectDescriptionHelpers
@preconcurrency import TuistPlugin

let project = ProjectFactory.createApp(
    name: "Travel",
    context: ProjectContext(
        metadata: ProjectMetadata(
            orgName: AppConfig.orgName,
            appBundleIDPrefix: AppConfig.orgName
        ),
        pathProvider: PathProvider(
            configDirectory: "Config"
        ),
        deploymentTarget: .iOS("17.0"),
        defaultSettings: .init()
    ),
    dependencies: [
        .SPM.kingfisher,
        .SPM.hwanKit,
        // .SPM.hwanMacros
//        .package(product: "Kingfisher", type: .runtime, condition: nil),
//        .package(product: "HawnKit", type: .runtime, condition: nil),
//        .package(product: "HwanMacros", type: .macro, condition: nil)
    ],
    packages: [
//        R.kingfisher,
//        R.hwanKit,
//        R.hwanMacros
    ],
    infoPlist: .storyBoardDefault
)
