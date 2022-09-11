//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITextFieldDelegate, ModelFromDelegate {
    
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
    private var userLanguage = "\(LanguageEnum.en)"
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
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
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.navigationBarColor)")
        button.setTitle(NSLocalizedString("MainViewController.logOutButton.title", comment: ""),
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
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        title = NSLocalizedString("MainViewController.title", comment: "")
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self,
                               forCellReuseIdentifier: MainTableViewCell.key)
        
        let leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        //MARK: - Добавление элементов на экран
        view.addSubview(mainView)
        mainView.addSubview(mainTableView)
        
        mainTableView.separatorStyle = .none
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.navigationBarColor)")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        updateViewConstraints()
        mainTableView.reloadData()
        makeRefresher()
        
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
            UserDefaults.standard.removeObject(forKey: "\(UserDefaultsKeysEnum.notFirstTime)")
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
    }
    
    func letTypeModels() {
        architectureTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0).lowercased() == "\(FireBaseTypeEnum.architecture)"
        }
        
        religionTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0).lowercased() == "\(FireBaseTypeEnum.religion)"
        }
        
        museumTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0).lowercased() == "\(FireBaseTypeEnum.museum)"
        }
        
        protectedAreasTypeArray = models.filter {
            FireBaseManager.shared.getModelType(model: $0).lowercased() == "\(FireBaseTypeEnum.conservation)"
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
    
    func openFavoriteVC(models: [QueryDocumentSnapshot]) {
        let viewController = FavouriteTypeViewController()
        viewController.setVar(setFavouriteModels: models)
        guard let model = models.first else {return}
        viewController.title = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelRusType(model: model) : FireBaseManager.shared.getModelType(model: model)
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
    
    func makeRefresher() {
        //MARK: - Работа с refresher to mainTableView
        let refresh = UIRefreshControl()
        mainTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refresher(sender: )), for: .valueChanged)
    }
    
    
    @objc private func refresher(sender: UIRefreshControl) {
        mainTableView.reloadData()
        sender.endRefreshing()
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
                    cell.typeNameLabel.text = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelRusType(model: model).uppercased() : FireBaseManager.shared.getModelType(model: model).uppercased()
                }
                
            case FireBaseTypeEnum.religion.rawValue:
                cell.models = religionTypeArray
                if let model = religionTypeArray.first {
                    cell.typeNameLabel.text = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelRusType(model: model).uppercased() : FireBaseManager.shared.getModelType(model: model).uppercased()
                }
                
            case FireBaseTypeEnum.museum.rawValue:
                cell.models = museumTypeArray
                if let model = museumTypeArray.first {
                    cell.typeNameLabel.text = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelRusType(model: model).uppercased() : FireBaseManager.shared.getModelType(model: model).uppercased()
                }
                
            case FireBaseTypeEnum.conservation.rawValue:
                cell.models = protectedAreasTypeArray
                if let model = protectedAreasTypeArray.first {
                    cell.typeNameLabel.text = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelRusType(model: model).uppercased() : FireBaseManager.shared.getModelType(model: model).uppercased()
                }
                
            default:
                ""
            }
            cell.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
            cell.selectionStyle = .none
            cell.forVC = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        240
    }
}

