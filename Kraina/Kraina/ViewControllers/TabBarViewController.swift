//
//  TabBarViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBarController?.delegate = self
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
        tabBar.barTintColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
        tabBar.unselectedItemTintColor = UIColor(named: "\(NameColorForThemesEnum.unselectedItemTintColor)")
        tabBar.tintColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        
        let MainVC = MainViewController()
        let MapVC = MapViewController()
        let FavoriteVC = FavoriteViewController()
        
        let navigationControllerMain = UINavigationController(rootViewController: MainVC)
        let navigationControllerMap = UINavigationController(rootViewController: MapVC)
        let navigationControllerFavorite = UINavigationController(rootViewController: FavoriteVC)
        
        viewControllers = [navigationControllerMain, navigationControllerMap, navigationControllerFavorite]
        navigationControllerMain.tabBarItem.title = NSLocalizedString("navigationControllerMain.tabBarItem.title",
                                                                      comment: "")
        navigationControllerMain.tabBarItem.image = UIImage(systemName: "house")
        
        navigationControllerMap.tabBarItem.title = NSLocalizedString("navigationControllerMap.tabBarItem.title",
                                                                     comment: "")
        navigationControllerMap.tabBarItem.image = UIImage(systemName: "map")
        
        navigationControllerFavorite.tabBarItem.title = NSLocalizedString("navigationControllerFavorite.tabBarItem.title",
                                                                          comment: "")
        navigationControllerFavorite.tabBarItem.image = UIImage(systemName: "bookmark")
        
        //Передаю модели на VC
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { models in
            MapVC.setModels(modelsForSet: models)
            MainVC.models = models
            FavoriteVC.setModels(modelsForSet: models)
        }
        
    }
    
    
}
