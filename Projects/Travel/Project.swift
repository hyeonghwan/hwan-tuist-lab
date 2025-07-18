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
        pathProvider: PathProvider(configDirectory: "Config"),
        deploymentTarget: .iOS("17.0"),
        defaultSettings: .init()
    ),
    dependencies: [
        .package(product: "Kingfisher", type: .runtime, condition: nil)
    ],
    packages: [
        R.kingfisher
    ],
    infoPlist: .storyBoardDefault
)
