//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITextFieldDelegate, ModelFromCollectionDelegate {
    
    //MARK: - Создание переменных
    var models: [QueryDocumentSnapshot] = [] {
        didSet {
            letTypeModels()
            mainTableView.reloadData()
        }
    }
    private var allTypeArray = [[QueryDocumentSnapshot]]()
    private var architectureTypeArray = [QueryDocumentSnapshot]()
    private var religionTypeArray = [QueryDocumentSnapshot]()
    private var museumTypeArray = [QueryDocumentSnapshot]()
    private var protectedAreasTypeArray = [QueryDocumentSnapshot]()
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 40,
                              height: 40)
        button.setImage(UIImage(systemName: "magnifyingglass"),
                        for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white,
                             for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self,
                         action: #selector(searchButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColorsEnum.mainAppUIColor
        button.setTitle("Выйти",
                        for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white,
                             for: .normal)
        button.setTitleColor(.green,
                             for: .highlighted)
        button.addTarget(self,
                         action: #selector(self.logOutButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        title = "Главная"
        view.backgroundColor = .white
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self,
                               forCellReuseIdentifier: MainTableViewCell.key)
        
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") {
            print ($0.first?.documentID)
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        //MARK: - Добавление элементов на экран
        view.addSubview(mainView)
        mainView.addSubview(mainTableView)
        
        mainTableView.separatorStyle = .none
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColorsEnum.mainAppUIColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        updateViewConstraints()
        mainTableView.reloadData()
    }
    
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        mainTableView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview()
        }

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
    
    //MARK: - метод для кнопки Найти в нав баре
    @objc private func searchButtonPressed() {
        let searchVC = SearchViewController()
        searchVC.models = models
        
        self.navigationController?.pushViewController(searchVC,
                                                      animated: true)
        
        print("search")
    }
    
    func letTypeModels() {
        architectureTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.architecture)"
        }
        
        religionTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.religion)"
        }
        
        museumTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.museum)"
        }
        
        protectedAreasTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0) == "\(FireBaseTypeEnum.protectedAreas)"
        }
        
        allTypeArray = [architectureTypeArray,
                        religionTypeArray,
                        museumTypeArray,
                        protectedAreasTypeArray]
    }
    
    func openModelVC(model: QueryDocumentSnapshot) {
        let modelViewController = ModelViewController()
        modelViewController.setModel(modelToSet: model)
        navigationController?.pushViewController(modelViewController,
                                                 animated: true)
    }
}

//MARK: - Работа с tableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        allTypeArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = mainTableView.dequeueReusableCell(withIdentifier: MainTableViewCell.key,
                                                        for: indexPath) as? MainTableViewCell {
            switch indexPath.row {
            case FireBaseTypeEnum.architecture.rawValue:
                cell.models = architectureTypeArray
                if let model = architectureTypeArray.first {
                    cell.typeNameLabel.text = FireBaseManager.shared.getModelRusType(model: model)
                }
                
            case FireBaseTypeEnum.religion.rawValue:
                cell.models = religionTypeArray
                if let model = religionTypeArray.first {
                    cell.typeNameLabel.text = FireBaseManager.shared.getModelRusType(model: model)
                }
                
            case FireBaseTypeEnum.museum.rawValue:
                cell.models = museumTypeArray
                if let model = museumTypeArray.first {
                    cell.typeNameLabel.text = FireBaseManager.shared.getModelRusType(model: model)
                }
                
            case FireBaseTypeEnum.protectedAreas.rawValue:
                cell.models = protectedAreasTypeArray
                if let model = protectedAreasTypeArray.first {
                    cell.typeNameLabel.text = FireBaseManager.shared.getModelRusType(model: model)
                }
            
            default:
                ""
            }
            
            cell.selectionStyle = .none
            cell.forVC = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        print("TableView")
    }

    
}

