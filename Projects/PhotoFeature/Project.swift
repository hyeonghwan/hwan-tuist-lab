@preconcurrency import ProjectDescription
import TuistPlugin
import ProjectDescriptionHelpers

let project = ProjectFactory.createApp(
    name: "PhotoFeature",
    context: ProjectContext(
        metadata: ProjectMetadata(
            orgName: AppConfig.orgName,
            appBundleIDPrefix: AppConfig.orgName
        ),
        pathProvider: PathProvider(
            projectConfigDirectory: "Projects/PhotoFeature/Config",
            configDirectory: "Config"
        ),
        deploymentTarget: .iOS("16.0"),
        defaultSettings: .init()
    ),
    dependencies: [
        .SPM.kingfisherPackage,
        .SPM.hwanKitPackage,
        .SPM.alamofirePackage,
        .SPM.hwanMacrosPackage
    ],
    packages: [
        R.kingfisher,
        R.hwanKit,
        R.alamofire,
        R.hwanMacros
    ],
    infoPlist: .codeDefault
)

