//
//  FavoriteViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController, UITabBarControllerDelegate {
    
    private var models: [QueryDocumentSnapshot]?
    private var favoriteModels = [QueryDocumentSnapshot]()
    private var favoritesNames: [String] = []
    
    //MARK: - Cоздание элементов UI
    private lazy var favoriteTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .white
        tabBarController?.delegate = self
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.key)
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColorsEnum.mainAppUIColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        updateFavoriteArray()
        
        
        view.addSubview(favoriteTableView)
        print(favoriteModels)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tabBarController?.delegate = self
    }
    
    //MARK: - Метод для передачи моделей из других VC
    func setModels(modelsForSet: [QueryDocumentSnapshot]) {
        models = modelsForSet
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        //для view для googleMaps
        favoriteTableView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        super.updateViewConstraints()
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2 {
            updateFavoriteArray()
            self.favoriteTableView.reloadData()
        }
    }
    
    func updateFavoriteArray() {
        FireBaseManager.shared.getUserFavoritesArray(completion: { [self] favorites in
            guard let models = models else {return}
            self.favoritesNames = favorites
            favoriteModels = models.filter { model in
                favoritesNames.contains(model.documentID)
            }
            favoriteTableView.reloadData()
        })
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let searchTableViewCell = favoriteTableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.key, for: indexPath) as? FavoriteTableViewCell {
            
            return searchTableViewCell
        }
        return UITableViewCell()
        
    }
    
    
}
