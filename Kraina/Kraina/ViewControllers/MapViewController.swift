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

class MapViewController: UIViewController, GMSMapViewDelegate, UITabBarControllerDelegate {
    
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
    
    private lazy var moveToButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = AppColorsEnum.mainAppUIColor
        moveButton.setTitle("Узнать больше", for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.addTarget(self, action: #selector(self.moveToButtonPressed), for: .touchUpInside)
        return moveButton
    }()
    
    
    lazy var modelCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 100, height: 30)
        
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        // collectionView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        collectionView.backgroundColor = .clear
        
        return collectionView
        
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
        popupView.addSubview(nameModelLabel)
        popupView.addSubview(adressModelLabel)
        popupView.addSubview(moveToButton)
        //view.addSubview(modelCollectionView)
        
        
        
        
        //Добавляю координаты моделей на карту для отображения маркеров и кластеров
        if let modelsUnwrapped = models {
            modelsUnwrapped.forEach({
                coordinatesArray.append(FireBaseManager.shared.getCoordinatesArray(model: $0))
            })
        } else {
            FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { [self] models in
                models.forEach({
                    self.coordinatesArray.append(FireBaseManager.shared.getCoordinatesArray(model: $0))
                })
                self.doClusters()
            }
        }
        
        
        //MARK: - Работа с googleMaps
        //Добавляю карту на view
        let camera = GMSCameraPosition.camera(withLatitude: 53.893009, longitude: 27.567444, zoom: 5.5)
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
        
        updateViewConstraints()
    }
    
    //MARK: - Функция по нажатию на кластер или маркер
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        mapView.animate(toLocation: marker.position)
        
        //Нажатие на кластер
        if marker.userData is GMUCluster {
            // zoom in on tapped cluster
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            NSLog("Did tap cluster")
            return true
        }
        
        FireBaseManager.shared.getModelByCoordinate(collection: "\(FireBaseCollectionsEnum.attraction)", latitude: marker.position.latitude) { QueryDocumentSnapshot in
            
            //MARK: - Текст для лейблов
            self.nameModelLabel.text = FireBaseManager.shared.getModelName(model: QueryDocumentSnapshot)
            self.adressModelLabel.text = FireBaseManager.shared.getModelAdress(model: QueryDocumentSnapshot)
            self.model = QueryDocumentSnapshot
            
            //достаю попап
            UIView.animate(withDuration: 0.3) {
                self.popupView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()}
                self.view.layoutIfNeeded()}
        }
        NSLog("Did tap a normal marker")
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //скрываю попап
        UIView.animate(withDuration: 0.3) {
            self.popupView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(250)}
            self.view.layoutIfNeeded()}
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
        
        moveToButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressModelLabel).inset(50)
            $0.height.equalTo(50)
        }
        
        modelCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        super.updateViewConstraints()
    }
    
    //MARK: - Действие кнопки moveToButton
    @objc private func moveToButtonPressed() {
        let modelViewController = ModelViewController()
        guard let modelUnwrapped = model else {return}
        modelViewController.setModel(modelToSet: modelUnwrapped)
        self.navigationController?.pushViewController(modelViewController, animated: true)
        print("LOL")
    }
    
    //MARK: - Метод для передачи моделей из других VC
    func setModels(modelsForSet: [QueryDocumentSnapshot]) {
        models = modelsForSet
    }
    
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
    
}

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionCell = modelCollectionView.dequeueReusableCell(withReuseIdentifier: ModelCollectionViewCell.key, for: indexPath) as? ModelCollectionViewCell {
            collectionCell.setLabel(setText: "dwadwdwadwada")
            collectionCell.backgroundColor = .white
            collectionCell.layer.cornerRadius = 10
            collectionCell.layer.borderWidth = 3
            collectionCell.layer.borderColor = AppColorsEnum.mainAppCGColor
            return collectionCell
        }
        return UICollectionViewCell()
    }

}

