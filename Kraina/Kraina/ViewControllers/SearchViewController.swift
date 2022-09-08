//
//  SearchViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 25.08.22.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    //MARK: - Создание переменных
    private var filteredModels: [QueryDocumentSnapshot] = []
    var models: [QueryDocumentSnapshot]?
    
    //MARK: - Cоздание элементов UI
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.placeholder = NSLocalizedString("SearchViewController.searchController.placeholder", comment: "")
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
        searchController.searchBar.setValue(NSLocalizedString("SearchViewController.searchController.searchBar", comment: ""), forKey: "cancelButtonText")
        return searchController
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
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self,
                                 forCellReuseIdentifier: SearchTableViewCell.key)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")

        //MARK: - Работа с searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        //MARK: - Работа с navigationController
        navigationItem.searchController = searchController
        definesPresentationContext = true
        //navigationItem.setHidesBackButton(true, animated: true)
        let yourBackImage = UIImage(named: "back_button_image")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        //MARK: - Добавление элементов на экран
        view.addSubview(searchTableView)
        
        backToVC()
    }
    
    //MARK: - метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    //MARK: - Метод для возврата назад свайпом
    func backToVC() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(back))
        swipeDownGesture.direction = .right
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func back() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
    }
    
    //MARK: - Методы для работы с searchController
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        filterModelsForSearch(searchText: text)
    }
    
    //MARK: - Метод для сравения введенного текста с массивом объектов по именам
    func filterModelsForSearch(searchText: String) {
        guard let models = models else {return}
        filteredModels = models.filter({
            FireBaseManager.shared.getModelName(model: $0).lowercased().contains(searchText.lowercased())
        })
        searchTableView.reloadData()
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        //для view для googleMaps
        searchTableView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        super.updateViewConstraints()
    }
}

//MARK: - Работа с tableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        filteredModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let searchTableViewCell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.key,
                                                                         for: indexPath) as? SearchTableViewCell {
            searchTableViewCell.nameModelLabel.text = FireBaseManager.shared.getModelName(model: filteredModels[indexPath.row])
            searchTableViewCell.iconImageView.image = UIImage(named: FireBaseManager.shared.getModelType(model: filteredModels[indexPath.row]))
            searchTableViewCell.typeModelLabel.text = FireBaseManager.shared.getModelRusType(model: filteredModels[indexPath.row])
            searchTableViewCell.sizeToFit()
            searchTableViewCell.backgroundColor = .clear
            
            return searchTableViewCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelViewController = ModelViewController()
        modelViewController.setModel(modelToSet: filteredModels[indexPath.row])
        self.navigationController?.pushViewController(modelViewController, animated: true)
    }
    
}
