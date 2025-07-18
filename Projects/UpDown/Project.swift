@preconcurrency import ProjectDescription
import TuistPlugin
import ProjectDescriptionHelpers

let project = ProjectFactory.createApp(
    name: "UpDown",
    context: ProjectContext(
        metadata: ProjectMetadata(
            orgName: AppConfig.orgName,
            appBundleIDPrefix: AppConfig.orgName
        ),
        pathProvider: PathProvider(
            projectConfigDirectory: "Config",
            configDirectory: "Projects/UpDown/Config"
        ),
        deploymentTarget: .iOS("17.0"),
        defaultSettings: .init()
    ),
    dependencies: [
    ],
    packages: [
    ],
    infoPlist: .storyBoardDefault
)
