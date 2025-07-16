import ProjectDescription


public extension InfoPlist {
    static var storyBoardDefault: InfoPlist {
        .extendingDefault(
            with: [
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                                "UISceneStoryboardFile": "Main"
                            ]
                        ]
                    ]
                ],
                "UILaunchScreen" : [
                    "UIImageName" : ""
                ]
            ]
        )
    }
}
