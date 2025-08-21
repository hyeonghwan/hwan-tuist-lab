import UIKit
import APIClient

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let sessionRegistry = AFSessionRegistry(monitor: APIEventLogger())
    lazy var defaultAPIClient = DefaultAPIClient(registry: sessionRegistry)
    let favoriteStore = FavoriteStore(cache: UserFavoriteCache.shared)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene

        let searchViewController = SearchViewController.create(
            with: SearchViewModel(
                favoriteStore: favoriteStore,
                provider: SearchProvider(
                    defaultAPIClient
                )
            )
        )
        
        let topicViewController = TopicViewController
            .create(
                with: TopicViewModel(
                    topicProvider: TopicProvider(defaultAPIClient)
                )
            )
        
        topicViewController.navigationItem.title = "OUR TOPIC"
        
        let nav1 = UINavigationController(rootViewController: topicViewController)
        nav1.navigationBar.prefersLargeTitles = false
        nav1.tabBarItem = UITabBarItem.init(
            title: nil,
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            tag: 0
        )
           
        let dummyOne = DummyViewController()
        dummyOne.tabBarItem = UITabBarItem.init(
            title: nil,
            image: UIImage(systemName: "play.rectangle"),
            tag: 1
        )
        
        let nav = UINavigationController(rootViewController: searchViewController)
        nav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2
        )
        
        let dummyTwo = DummyViewController()
        dummyTwo.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            tag: 3
        )
        
        let tabBarController = UITabBarController()
        
        tabBarController.setViewControllers([nav1, dummyOne , nav, dummyTwo], animated: false)
        tabBarController.tabBar.tintColor = .black
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

final class DummyViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .white
    }
}
