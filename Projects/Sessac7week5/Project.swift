@preconcurrency import ProjectDescription
import TuistPlugin
import ProjectDescriptionHelpers

let project = ProjectFactory.createApp(
    name: "Sessac7week5",
    context: ProjectContext(
        metadata: ProjectMetadata(
            orgName: AppConfig.orgName,
            appBundleIDPrefix: AppConfig.orgName
        ),
        pathProvider: PathProvider(
            projectConfigDirectory: "Projects/Sessac7week5/Config",
            configDirectory: "Config"
        ),
        deploymentTarget: .iOS("17.0"),
        defaultSettings: .init()
    ),
    dependencies: [
        .package(product: "Kingfisher", type: .runtime, condition: nil),
        .package(product: "HawnKit", type: .runtime, condition: nil),
        .package(product: "CombineInterception", type: .runtime, condition: nil),
        .package(product: "Alamofitre", type: .runtime, condition: nil),
        .SPM.hwanMacros
    ],
    packages: [
//        R.alamofire,
//        R.kingfisher,
//        R.combineInterception,
//        R.hwanKit,
        R.hwanMacros
    ],
    infoPlist: .storyBoardDefault
)
