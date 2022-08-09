//
//  TabBarViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        tabBar.backgroundColor = UIColor.white
        guard let MainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainViewController else {return}
        guard let MapVC = UIStoryboard(name: "MapStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MapStoryboard") as? MapViewController else {return}
        guard let FavotiteVC = UIStoryboard(name: "FavoriteStoryboard", bundle: nil).instantiateViewController(withIdentifier: "FavoriteStoryboard") as? FavoriteViewController else {return}

                viewControllers = [MainVC, MapVC, FavotiteVC]
        MainVC.tabBarItem.title = "Главная"
        MainVC.tabBarItem.image = UIImage(systemName: "house")
        
        MapVC.tabBarItem.title = "Карта"
        MapVC.tabBarItem.image = UIImage(systemName: "map")
        
        FavotiteVC.tabBarItem.title = "Избранное"
        FavotiteVC.tabBarItem.image = UIImage(systemName: "bookmark")
    }
    

}
