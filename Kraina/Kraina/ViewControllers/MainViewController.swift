//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Создание переменных
    var documentArray: [FireBaseDocument] = []
    var coordinatesArray: [Double] = []
    var userFavorites: [String]?
    var models: [QueryDocumentSnapshot]?
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColorsEnum.mainAppUIColor
        button.setTitle("Выйти", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self, action: #selector(self.logOutButtonPressed), for: .touchUpInside)
        button.dropShadow()
        return button
    }()
    
    private lazy var getDataButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColorsEnum.mainAppUIColor
        button.setTitle("Получить", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self, action: #selector(self.getDataButtonPressed), for: .touchUpInside)
        button.dropShadow()
        return button
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        title = "Главная"
        view.backgroundColor = .white
        
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { models in
            print (models.first?.documentID)
        }
        
        //MARK: - Добавление элементов на экран
        view.addSubview(mainView)
        mainView.addSubview(logOutButton)
        mainView.addSubview(getDataButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColorsEnum.mainAppUIColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        updateViewConstraints()
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        logOutButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        getDataButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.equalTo(logOutButton).inset(50)
        }

        hideKeyboardWhenTappedAround()
        super.updateViewConstraints()
    }
    
    //MARK: - Действие кнопки logOut
    @objc private func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    @objc private func getDataButtonPressed() {
        
    }
    
    //MARK: - метод для кнопки добавить в избранное в нав баре
    @objc private func searchButtonPressed() {
        let searchVC = SearchViewController()
        //        let navigationControllerMain = UINavigationController(rootViewController: searchVC)
        //        present(navigationControllerMain, animated: true)
        searchVC.models = models
        
        self.navigationController?.pushViewController(searchVC, animated: true)

        print("search")
    }
}
