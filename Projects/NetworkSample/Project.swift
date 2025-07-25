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
        .SPM.hwanMacros,
        .SPM.kingfisher,
        .SPM.hwanKit,
        .SPM.alamofire
    ],
    packages: [
        R.hwanMacros
    ],
    infoPlist: .codeDefault
)
