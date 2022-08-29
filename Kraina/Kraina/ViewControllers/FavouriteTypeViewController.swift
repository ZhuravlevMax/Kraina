//
//  FavouriteTypeViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 28.08.22.
//

import UIKit
import Firebase

class FavouriteTypeViewController: UIViewController {
    
    //MARK: - Создание переменных
    private var favouriteModels = [QueryDocumentSnapshot]()
    
    //MARK: - Создание элементов UI
    private lazy var favoutiteTypeTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = AppColorsEnum.mainAppUIColor
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
        
        view.backgroundColor = .white
        
        
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
        
        guard let firstModel = favouriteModels.first else {return}
        print(FireBaseManager.shared.getModelName(model: firstModel))
        
    }
    
    func setVar(setFavouriteModels: [QueryDocumentSnapshot]) {
        favouriteModels = setFavouriteModels
    }
    
    private func initialize() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                    for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
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
extension FavouriteTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favoutiteTypeTableView.dequeueReusableCell(withIdentifier: FavouriteTypeTableViewCell.key,
                                                                 for: indexPath) as? FavouriteTypeTableViewCell {
            cell.nameModelLabel.text = FireBaseManager.shared.getModelName(model: favouriteModels[indexPath.row])
            cell.setImage(model: favouriteModels[indexPath.row])
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
        modelViewController.setModel(modelToSet: favouriteModels[indexPath.row])
        self.navigationController?.pushViewController(modelViewController, animated: true)
    }
    
    //MARK: - метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
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
    }
}
