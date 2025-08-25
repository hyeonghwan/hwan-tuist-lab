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
    
    static func codeDefaultWith(extra: [String: ProjectDescription.Plist.Value]) -> InfoPlist {
        let base: [String: ProjectDescription.Plist.Value] = [
            "TARGETED_DEVICE_FAMILY": "1",
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait"
            ],
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
            "UILaunchScreen": [
                "UIImageName": ""
            ]
        ]
        let merged = base.merging(extra) { _, new in new }
        return .extendingDefault(with: merged)
    }
    
    static var codeDefault: InfoPlist {
        .extendingDefault(
            with: [
                "TARGETED_DEVICE_FAMILY": "1",
                "UISupportedInterfaceOrientations": [
                    "UIInterfaceOrientationPortrait"
                ],
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
