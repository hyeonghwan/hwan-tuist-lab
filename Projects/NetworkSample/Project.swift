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
    infoPlist: .codeDefaultWith(extra: [
        "OPEN_WEATHER_API_KEY": "$(OPEN_WEATHER_API_KEY)",
        "MOVIE_API_KEY": "$(MOVIE_API_KEY)",
        "NAVER_CLIENT_ID": "$(NAVER_CLIENT_ID)",
        "NAVER_CLIENT_SECRET": "$(NAVER_CLIENT_SECRET)",
        "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
    ])
)
