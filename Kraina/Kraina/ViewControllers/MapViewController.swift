//
//  MapViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import SnapKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import CoreLocation
import FloatingPanel

class MapViewController: UIViewController,
                         GMSMapViewDelegate,
                         UITabBarControllerDelegate,
                         ChangeTypeDelegate,
                         FloatingPanelControllerDelegate,
                         MapViewDelegate {
    
    //MARK: - Создание переменных
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    private var models: [QueryDocumentSnapshot]?
    private var model: QueryDocumentSnapshot?
    private var coordinatesArray: [[Double]] = []
    private var markerArray: [GMSMarker] = []
    
    //MARK: - Cоздание элементов UI
    private var forMapView: UIView = {
        let viewForMap = UIView()
        return viewForMap
    }()
    
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var nameModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var adressModelLabel: UILabel = {
        let adressLabel = UILabel()
        adressLabel.numberOfLines = 0
        adressLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return adressLabel
    }()
    
    private lazy var showModel: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = AppColorsEnum.mainAppUIColor
        moveButton.setTitle("Узнать больше", for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.addTarget(self, action: #selector(self.showModelPressed), for: .touchUpInside)
        return moveButton
    }()
    
    
    lazy var modelCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 130, height: 40)
        
        //        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
        
    }()
    
    private lazy var searchButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = .white
        moveButton.layer.cornerRadius = 10
        moveButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        moveButton.layer.borderColor = AppColorsEnum.borderCGColor
        moveButton.layer.borderWidth = 1
        moveButton.tintColor = AppColorsEnum.mainAppUIColor
        moveButton.addTarget(self, action: #selector(self.searchButtonPressed), for: .touchUpInside)
        return moveButton
    }()
    
    private lazy var fpc: FloatingPanelController = {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        return fpc
    }()
    
    private lazy var appearance: SurfaceAppearance = {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 15
        return appearance
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
        
        
        modelCollectionView.delegate = self
        modelCollectionView.dataSource = self
        modelCollectionView.register(ModelCollectionViewCell.self, forCellWithReuseIdentifier: ModelCollectionViewCell.key)
        
        forMapView.frame = view.frame
        view.backgroundColor = .white
        self.tabBarController?.delegate = self
        
        //MARK: - Добавление элементов на экран
        view.addSubview(forMapView)
        view.addSubview(modelCollectionView)
        view.addSubview(popupView)
        view.addSubview(searchButton)
        popupView.addSubview(nameModelLabel)
        popupView.addSubview(adressModelLabel)
        popupView.addSubview(showModel)
        
        //Добавляю координаты моделей на карту для отображения маркеров и кластеров
        if let modelsUnwrapped = models {
            modelsUnwrapped.forEach({
                coordinatesArray.append(FireBaseManager.shared.getCoordinatesArray(model: $0))
            })
        } else {
            FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { [weak self] models in
                models.forEach({
                    guard let self = self else {return}
                    self.coordinatesArray.append(FireBaseManager.shared.getCoordinatesArray(model: $0))
                })
                guard let self = self else {return}
                self.doClusters()
            }
        }
        
        
        //MARK: - Работа с googleMaps
        //Добавляю карту на view
        let camera = GMSCameraPosition.camera(withLatitude: 53.893009, longitude: 27.567444, zoom: 5)
        self.mapView = GMSMapView.map(withFrame: self.forMapView.frame, camera: camera)
        self.forMapView.addSubview(self.mapView)
        
        self.mapView.delegate = self
        
        //Работа с кластерами
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algoritm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: self.mapView, clusterIconGenerator: iconGenerator)
        self.clusterManager = GMUClusterManager(map: self.mapView, algorithm: algoritm, renderer: renderer)
        self.clusterManager.setMapDelegate(self)
        
        doClusters()
        
        //MARK: - Работа с всплывающим попапом
        fpc.surfaceView.appearance = self.appearance
        fpc.layout = MyFloatingPanelLayout()
        fpc.addPanel(toParent: self)
        
        updateViewConstraints()
    }
    
    //MARK: - Функция по нажатию на кластер или маркер
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        mapView.animate(toLocation: marker.position)
        
        //Нажатие на кластер
        if marker.userData is GMUCluster {
            // zoom in on tapped cluster
            mapView.animate(toZoom: mapView.camera.zoom + 2)
            NSLog("Did tap cluster")
            return true
        }
        
        FireBaseManager.shared.getModelByCoordinate(collection: "\(FireBaseCollectionsEnum.attraction)",
                                                    latitude: marker.position.latitude) { [weak self] QueryDocumentSnapshot in
            
            guard let self = self else {return}
            //fpc.removePanelFromParent(animated: true)
            let popupVC = PopupMapViewController()
            popupVC.setModel(setModel: QueryDocumentSnapshot)
            popupVC.mapView = self
            self.fpc.set(contentViewController: popupVC)
            self.fpc.addPanel(toParent: self)
            self.fpc.move(to: .half, animated: true)
            
            
            //            //MARK: - Текст для лейблов
            //            self.nameModelLabel.text = FireBaseManager.shared.getModelName(model: QueryDocumentSnapshot)
            //            self.adressModelLabel.text = FireBaseManager.shared.getModelAdress(model: QueryDocumentSnapshot)
            //            self.model = QueryDocumentSnapshot
            //
            //            //достаю попап
            //            UIView.animate(withDuration: 0.3) {
            //                self.popupView.snp.updateConstraints {
            //                    $0.bottom.equalToSuperview()}
            //                self.view.layoutIfNeeded()}
        }
        
        //Вибрация при тапе на иконку
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        NSLog("Did tap a normal marker")
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //
        //        //скрываю попап
        //        UIView.animate(withDuration: 0.3) {
        //            self.popupView.snp.updateConstraints {
        //                $0.bottom.equalToSuperview().offset(250)}
        //            self.view.layoutIfNeeded()}
    }
    
    //MARK: - Метод для задания сдвига попапа, когда тянешь
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        if vc.isAttracting == false {
            let loc = vc.surfaceLocation
            let minY = vc.surfaceLocation(for: .half).y - 16.0
            let maxY = vc.surfaceLocation(for: .tip).y + 6.0
            vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        //для view для googleMaps
        forMapView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        //popup view
        popupView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(250)
            $0.bottom.equalToSuperview().offset(250)
            // $0.width.equalToSuperview()
        }
        
        nameModelLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
        }
        
        adressModelLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(nameModelLabel).inset(50)
        }
        
        showModel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressModelLabel).inset(50)
            $0.height.equalTo(50)
        }
        
        modelCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        searchButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-180)
            $0.height.width.equalTo(50)
        }
        super.updateViewConstraints()
    }
    
    //MARK: - Действие кнопки showModel
    @objc private func showModelPressed() {
        //showModel()
    }
    
    //MARK: - Действие кнопки searchButton
    @objc private func searchButtonPressed() {
        let searchVC = SearchOnMapViewController()
        let navigationControllerMain = UINavigationController(rootViewController: searchVC)
        searchVC.models = models
        searchVC.mapVC = self
        present(navigationControllerMain, animated: true)
        
        print("search")
    }
    
    //MARK: - Метод для передачи моделей из других VC
    func setModels(modelsForSet: [QueryDocumentSnapshot]) {
        models = modelsForSet
    }
    
    //MARK: - Метод для перехода на локацию маркера из поиска
    func moveTo(latData: Double,lonData: Double ) {
        mapView.animate(to: GMSCameraPosition.camera(withLatitude: latData, longitude: lonData, zoom: 8))
    }
    
    //MARK: - Метод для выбора категорий по нажатию на ячейку через делегат
    func changeMarkerType(modelsSet: [QueryDocumentSnapshot]) {
        markerArray.removeAll()
        mapView.clear()
        clusterManager.clearItems()
        modelsSet.forEach {
            let coordinate = FireBaseManager.shared.getCoordinatesArray(model: $0)
            let position = CLLocationCoordinate2D(latitude: coordinate[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinate[FirebaseCoordinateEnum.longtitude.rawValue])
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: FireBaseManager.shared.getModelType(model: $0))
            self.markerArray.append(marker)
        }
        
        //Добавляю точки в менеджер кластеров
        self.clusterManager.add(self.markerArray)
        
        self.clusterManager.cluster()
    }
    
    //MARK: - Метод добавления кластеров на карту
    func doClusters() {
        guard let models = models else {return}
        
        models.forEach {
            let coordinate = FireBaseManager.shared.getCoordinatesArray(model: $0)
            let position = CLLocationCoordinate2D(latitude: coordinate[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinate[FirebaseCoordinateEnum.longtitude.rawValue])
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: FireBaseManager.shared.getModelType(model: $0))
            self.markerArray.append(marker)
        }
        
        //Добавляю точки в менеджер кластеров
        self.clusterManager.add(self.markerArray)
        
        self.clusterManager.cluster()
    }
    
    func showModel(model: QueryDocumentSnapshot) {
        let modelViewController = ModelViewController()
        modelViewController.setModel(modelToSet: model)
        self.navigationController?.pushViewController(modelViewController,
                                                      animated: true)
    }
    
}

//MARK: - Работа с СollectionView
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FireBaseTypeEnum.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionCell = modelCollectionView.dequeueReusableCell(withReuseIdentifier: ModelCollectionViewCell.key, for: indexPath) as? ModelCollectionViewCell,
           let imageAll = UIImage(named: "\(FireBaseTypeEnum.all)"),
           let imageArchitecture = UIImage(named: "\(FireBaseTypeEnum.architecture)"),
           let imageReligion = UIImage(named: "\(FireBaseTypeEnum.religion)"),
           let imageMuseum = UIImage(named: "\(FireBaseTypeEnum.museum)"),
           let imageProtectedAreas = UIImage(named: "\(FireBaseTypeEnum.protectedAreas)") {
            if let modelsUnwrapped = models {
                switch indexPath.row {
                case FireBaseTypeEnum.all.rawValue:
                    collectionCell.setVar(setText: "Все",
                                          setType: "\(FireBaseTypeEnum.all)",
                                          image: imageAll,
                                          modelsSet: modelsUnwrapped)
                    
                case FireBaseTypeEnum.architecture.rawValue:
                    collectionCell.setVar(setText: "Архитектура",
                                          setType: "\(FireBaseTypeEnum.architecture)",
                                          image: imageArchitecture,
                                          modelsSet: modelsUnwrapped)
                    
                case FireBaseTypeEnum.religion.rawValue:
                    collectionCell.setVar(setText: "Религия",
                                          setType: "\(FireBaseTypeEnum.religion)",
                                          image: imageReligion,
                                          modelsSet: modelsUnwrapped)
                    
                case FireBaseTypeEnum.museum.rawValue:
                    collectionCell.setVar(setText: "Музеи",
                                          setType: "\(FireBaseTypeEnum.museum)",
                                          image: imageMuseum,
                                          modelsSet: modelsUnwrapped)
                    
                case FireBaseTypeEnum.protectedAreas.rawValue:
                    collectionCell.setVar(setText: "Заповедные территории",
                                          setType: "\(FireBaseTypeEnum.protectedAreas)",
                                          image: imageProtectedAreas,
                                          modelsSet: modelsUnwrapped)
                    
                default:
                    ""
                }
            }
            
            collectionCell.changeTypeDelegate = self
            collectionCell.backgroundColor = .white
            collectionCell.layer.cornerRadius = 5
            collectionCell.layer.borderWidth = 1
            collectionCell.layer.borderColor = AppColorsEnum.borderCGColor
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 20,
                            bottom: 20,
                            right: 20)
    }
    
}

