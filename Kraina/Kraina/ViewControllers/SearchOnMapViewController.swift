//
//  SearchOnMapViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 3.09.22.
//

import UIKit
import Firebase
import GoogleMaps

class SearchOnMapViewController: UIViewController {
    
    //MARK: - Создание переменных
    private var filteredModels: [QueryDocumentSnapshot] = []
    var models: [QueryDocumentSnapshot]?
    weak var mapVC: MapViewDelegate?
    
    //MARK: - Cоздание элементов UI
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = AppColorsEnum.mainAppUIColor
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.placeholder = "Введите название достопримечательности"
        return searchController
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
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self,
                                 forCellReuseIdentifier: SearchTableViewCell.key)
        
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
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        //MARK: - Добавление элементов на экран
        view.addSubview(searchTableView)
        
        backToVC()
    }
    
    //MARK: - метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        dismiss(animated: true)
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

extension SearchOnMapViewController: UITableViewDelegate,
                                     UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        filteredModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let searchTableViewCell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.key,
                                                                         for: indexPath) as? SearchTableViewCell {
            searchTableViewCell.nameModelLabel.text = FireBaseManager.shared.getModelName(model: filteredModels[indexPath.row])
            searchTableViewCell.iconImageView.image = UIImage(named: FireBaseManager.shared.getModelType(model: filteredModels[indexPath.row]))
            searchTableViewCell.typeModelLabel.text = FireBaseManager.shared.getModelRusType(model: filteredModels[indexPath.row])
            searchTableViewCell.sizeToFit()
            
            return searchTableViewCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        dismiss(animated: true)
        
        let coordinates = FireBaseManager.shared.getCoordinatesArray(model: filteredModels[indexPath.row])
        guard let mapVCUnwrapped = mapVC,
              let modelsUnwrapped = models else {return}
        mapVCUnwrapped.doClustersFromSearch(models: modelsUnwrapped)
        mapVCUnwrapped.didTapIconFromSearchMapVC(model: filteredModels[indexPath.row] )
        mapVCUnwrapped.moveTo(latData: coordinates[FirebaseCoordinateEnum.latitude.rawValue], lonData: coordinates[FirebaseCoordinateEnum.longtitude.rawValue])
    }
    
}

extension SearchOnMapViewController: UISearchResultsUpdating {
    
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
        print(text)
    }
    
    //MARK: - Метод для сравения введенного текста с массивом объектов по именам
    func filterModelsForSearch(searchText: String) {
        guard let models = models,
              let text = searchController.searchBar.text else {return}
        filteredModels = models.filter({
            FireBaseManager.shared.getModelName(model: $0).lowercased().contains(searchText.lowercased())
        })
        searchTableView.reloadData()
        print(filteredModels)
    }
}




