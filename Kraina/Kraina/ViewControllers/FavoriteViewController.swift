//
//  FavoriteViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController, UITabBarControllerDelegate {
    
    //MARK: - Cоздание переменных
    private var models: [QueryDocumentSnapshot]?
    private var favoriteModels = [QueryDocumentSnapshot]()
    private var favouriteTypeArray: [[QueryDocumentSnapshot]] = []
    private var architectureTypeArray = [QueryDocumentSnapshot]()
    private var religionTypeArray = [QueryDocumentSnapshot]()
    private var museumTypeArray = [QueryDocumentSnapshot]()
    private var favoritesNames: [String] = []
    
    //MARK: - Cоздание элементов UI
    lazy var favoriteCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .white
        tabBarController?.delegate = self
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.self,
                                        forCellWithReuseIdentifier: FavoriteCollectionViewCell.key)
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColorsEnum.mainAppUIColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        updateFavoriteArray()
        
        //MARK: - добавление элементов UI на View
        view.addSubview(favoriteCollectionView)
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
        
        favoriteCollectionView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        super.updateViewConstraints()
    }
    
    //MARK: - Метод для обновления VC через тап на tabbar item
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2 {
            updateFavoriteArray()
            self.favoriteCollectionView.reloadData()
        }
    }
    
    //MARK: - Метод для обновления массива избранного
    func updateFavoriteArray() {
        FireBaseManager.shared.getUserFavoritesArray(completion: { [self] favorites in
            guard let models = models else {return}
            self.favoritesNames = favorites
            favoriteModels = models.filter { model in
                favoritesNames.contains(model.documentID)
            }
            favouriteTypeArray.removeAll()
            
            architectureTypeArray = favoriteModels.filter {
                FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.architecture)"
            }
            
            religionTypeArray = favoriteModels.filter {
                FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.religion)"
            }
            
            museumTypeArray = favoriteModels.filter {
                FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.museum)"
            }
            
            architectureTypeArray.isEmpty ? () : (favouriteTypeArray.append(architectureTypeArray))
            religionTypeArray.isEmpty ? () : (favouriteTypeArray.append(religionTypeArray))
            museumTypeArray.isEmpty ? () : (favouriteTypeArray.append(museumTypeArray))
            //favouriteTypeArray = [architectureTypeArray, religionTypeArray, museumTypeArray]
            
            print(favouriteTypeArray)
            favoriteCollectionView.reloadData()
        })
    }
}

//MARK: - Работа с collectionView
extension FavoriteViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        favouriteTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionCell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.key,
                                                                           for: indexPath) as? FavoriteCollectionViewCell {
            
            if let model = favouriteTypeArray[indexPath.row].first {
                collectionCell.setVar(setText: FireBaseManager.shared.getModelRusType(model: model),
                                      count: favouriteTypeArray[indexPath.row].count)
            }
            collectionCell.backgroundColor = .white
            collectionCell.layer.cornerRadius = 5
            collectionCell.layer.borderColor = AppColorsEnum.borderCGColor
            collectionCell.dropShadow(width: 2, height: 3)
            
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.size.width
        return CGSize(width: width * 0.41, height: width * 0.3)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 20,
                            bottom: 20,
                            right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let model = favouriteTypeArray[indexPath.row].first else {return}
        let favouriteTypeVC = FavouriteTypeViewController()
        favouriteTypeVC.setVar(setFavouriteModels: favouriteTypeArray[indexPath.row])
        favouriteTypeVC.title = FireBaseManager.shared.getModelRusType(model: model)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.pushViewController(favouriteTypeVC, animated: true)
        
    }
    
    
    
    
}
