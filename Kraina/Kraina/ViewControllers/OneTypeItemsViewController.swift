//
//  OneTypeItemsViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.09.22.
//

import UIKit
import Firebase

class OneTypeItemsViewController: UIViewController {
    
    //MARK: - Создание переменных
    private var models = [QueryDocumentSnapshot]()
    var favouriteVC: CheckFavouriteDelegate?
    
    //MARK: - Создание элементов UI
    private lazy var favoutiteTypeTableView: UITableView = {
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
        
        favoutiteTypeTableView.delegate = self
        favoutiteTypeTableView.dataSource = self
        favoutiteTypeTableView.register(FavouriteTypeTableViewCell.self,
                                        forCellReuseIdentifier: FavouriteTypeTableViewCell.key)
        favoutiteTypeTableView.separatorStyle = .none
        
        view.addSubview(favoutiteTypeTableView)
        
        initialize()
        backToRoot()
        updateViewConstraints()
        favoutiteTypeTableView.reloadData()

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
        favoutiteTypeTableView.snp.makeConstraints {
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
        if let cell = favoutiteTypeTableView.dequeueReusableCell(withIdentifier: FavouriteTypeTableViewCell.key,
                                                                 for: indexPath) as? FavouriteTypeTableViewCell {
            cell.setVar(nameModel: Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelName(model: models[indexPath.row]) : FireBaseManager.shared.getModelNameEn(model: models[indexPath.row]))
            cell.setImage(model: models[indexPath.row])
            cell.selectionStyle = .none
            
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
        favoutiteTypeTableView.reloadData()
    }
}
