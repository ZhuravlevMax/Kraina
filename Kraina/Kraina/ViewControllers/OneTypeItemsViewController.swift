//
//  OneTypeItemsViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.09.22.
//

import UIKit
import Firebase

class OneTypeItemsViewController: UIViewController,
                                  OneTypeVCDelegate {
    
    //MARK: - Создание переменных
    private var models = [QueryDocumentSnapshot]()
    var favouriteVC: CheckFavouriteDelegate?
    
    //MARK: - Создание элементов UI
    private lazy var oneTypeTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 35,
                              height: 35)
        button.setImage(UIImage(systemName: "chevron.backward"),
                        for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white,
                             for: .normal)
        button.addTarget(self,
                         action: #selector(backButtonPressed),
                         for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        oneTypeTableView.delegate = self
        oneTypeTableView.dataSource = self
        oneTypeTableView.register(FavouriteTypeTableViewCell.self,
                                        forCellReuseIdentifier: FavouriteTypeTableViewCell.key)
        oneTypeTableView.separatorStyle = .none
        
        view.addSubview(oneTypeTableView)
        
        initialize()
        backToRoot()
        updateViewConstraints()
        oneTypeTableView.reloadData()

    }

    func setVar(setModels: [QueryDocumentSnapshot]) {
        models = setModels
    }
    
    private func initialize() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                    for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        oneTypeTableView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        super.updateViewConstraints()
    }
}


//MARK: - Работа с tableView
extension OneTypeItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = oneTypeTableView.dequeueReusableCell(withIdentifier: FavouriteTypeTableViewCell.key,
                                                                 for: indexPath) as? FavouriteTypeTableViewCell {
            cell.setVar(nameModel: Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelName(model: models[indexPath.row]) : FireBaseManager.shared.getModelNameEn(model: models[indexPath.row]))
            cell.setImage(model: models[indexPath.row])
            cell.selectionStyle = .none
            cell.model = models[indexPath.row]
            cell.oneTypeItemsVC = self
    
            
            FireBaseManager.shared.getUserFavoritesArray { [weak self] favouriteArray in
                guard let self = self else {return}
                if favouriteArray.contains(self.models[indexPath.row].documentID) {
                    cell.addToFavoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    cell.addToFavoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelViewController = ModelViewController()
        modelViewController.setModel(modelToSet: models[indexPath.row])
        modelViewController.favouriteModels = models
        modelViewController.oneTypeItemsVC = self
        self.navigationController?.pushViewController(modelViewController, animated: true)
    }
    
    //MARK: - метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
        guard let favouriteVCUnwrapped = favouriteVC else {return}
        
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { models in
            favouriteVCUnwrapped.setFavouriteArray(modelsArray: models)
        }
    }
    
    func backToRoot() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(back))
        swipeDownGesture.direction = .right
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func back() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
        guard let favouriteVCUnwrapped = favouriteVC else {return}
        
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { models in
            favouriteVCUnwrapped.setFavouriteArray(modelsArray: models)
        }
    }
    
    func setFavouriteArray(modelsArray: [QueryDocumentSnapshot]) {
        models = modelsArray
        oneTypeTableView.reloadData()
    }
    
    func reloadOneTypeTableView() {
        oneTypeTableView.reloadData()
    }
    
    func addToFavouriteFromCell(model: QueryDocumentSnapshot) {
        FireBaseManager.shared.getUserFavoritesArray { [weak self] favorites in
            var favoritesArray = favorites
            guard let userId = Auth.auth().currentUser?.uid,
                  let self = self
            else {return}
            
            if favoritesArray.contains(model.documentID) {
                if favoritesArray.contains("\(model.documentID)"){favoritesArray.removeAll(where:{ "\(model.documentID)" == $0 })}
                let ref = Database.database().reference().child("\(UsersFieldsEnum.users)")
                ref.child(userId).updateChildValues(["\(UsersFieldsEnum.favorites)" : favoritesArray])
                self.oneTypeTableView.reloadData()
            } else {
                favoritesArray.append("\(model.documentID)")
                let ref = Database.database().reference().child("\(UsersFieldsEnum.users)")
                ref.child(userId).updateChildValues(["\(UsersFieldsEnum.favorites)" : favoritesArray])
                self.oneTypeTableView.reloadData()
            }

        }
        //вибрация по нажатию на иконку
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        //oneTypeTableView.reloadData()
    }
}
