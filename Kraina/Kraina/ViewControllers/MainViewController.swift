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
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColorsEnum.mainAppColor
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
        button.backgroundColor = AppColorsEnum.mainAppColor
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
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColorsEnum.mainAppColor
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
}
