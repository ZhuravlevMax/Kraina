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
        
        tabBar.backgroundColor = UIColor.white
        //        guard let MainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainViewController else {return}
        //        guard let MapVC = UIStoryboard(name: "MapStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MapStoryboard") as? MapViewController else {return}
        //        guard let FavotiteVC = UIStoryboard(name: "FavoriteStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FavoriteStoryboard") as? FavoriteViewController else {return}
        
        let MainVC = MainViewController()
        let MapVC = MapViewController()
        let FavoriteVC = FavoriteViewController()
        
        let navigationControllerMain = UINavigationController(rootViewController: MainVC)
        let navigationControllerMap = UINavigationController(rootViewController: MapVC)
        let navigationControllerFavorite = UINavigationController(rootViewController: FavoriteVC)
        
        viewControllers = [navigationControllerMain, navigationControllerMap, navigationControllerFavorite]
        navigationControllerMain.tabBarItem.title = "Главная"
        navigationControllerMain.tabBarItem.image = UIImage(systemName: "house")
        
        navigationControllerMap.tabBarItem.title = "Карта"
        navigationControllerMap.tabBarItem.image = UIImage(systemName: "map")
        
        navigationControllerFavorite.tabBarItem.title = "Избранное"
        navigationControllerFavorite.tabBarItem.image = UIImage(systemName: "bookmark")
        
        //Передаю модели на VC
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { models in
            MapVC.setModels(modelsForSet: models)
            MainVC.models = models
            FavoriteVC.setModels(modelsForSet: models)
        }

        tabBar.tintColor = AppColorsEnum.mainAppUIColor
        
    }
    
    
}
