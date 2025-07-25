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
    static var codeDefault: InfoPlist {
        .extendingDefault(
            with: [
                "OPEN_WEATHER_API_KEY": "$(OPEN_WEATHER_API_KEY)",
                "MOVIE_API_KEY": "$(MOVIE_API_KEY)",
                "NAVER_CLIENT_ID": "$(NAVER_CLIENT_ID)",
                "NAVER_CLIENT_SECRET": "$(NAVER_CLIENT_SECRET)",
                "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
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
