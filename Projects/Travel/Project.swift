import ProjectDescription
import TuistPlugin

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
        .external(name: "Kingfisher")
    ],
    infoPlist: .default
)
