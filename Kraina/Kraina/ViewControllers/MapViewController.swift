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

class MapViewController: UIViewController, GMSMapViewDelegate, UITabBarControllerDelegate {
    
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    private var models: [QueryDocumentSnapshot]?
    private var model: QueryDocumentSnapshot?
    private var coordinatesArray: [[Double]] = []
    private var markerArray: [GMSMarker] = []
    
    private lazy var forMapView = UIView()
    private lazy var popupView = UIView()
    private var nameModelLabel = UILabel()
    private var adressModelLabel = UILabel()
    private var moveToButton = UIButton()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
        
        view.backgroundColor = .white
        self.tabBarController?.delegate = self
        
        //Добавляю координаты моделей на карту для отображения маркеров и кластеров
        guard let modelsUnwrapped = models else {return}
        modelsUnwrapped.forEach({
            coordinatesArray.append(FireBaseManager.shared.getCoordinatesArray(model: $0))
        })
        
        //View for googleMaps
        forMapView.frame = view.frame
        
        //MARK: - Добавление элементов на экран
        view.addSubview(forMapView)
        view.addSubview(popupView)
        popupView.addSubview(nameModelLabel)
        popupView.addSubview(adressModelLabel)
        popupView.addSubview(moveToButton)
        
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
        
        for coordinate in self.coordinatesArray {
            let position = CLLocationCoordinate2D(latitude: coordinate[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinate[FirebaseCoordinateEnum.longtitude.rawValue])
            let marker = GMSMarker(position: position)
            
            self.markerArray.append(marker)
        }
        
        //Добавляю точки в менеджер кластеров
        self.clusterManager.add(self.markerArray)
        
        self.clusterManager.cluster()
        
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
            //print(FireBaseManager.shared.getImagesPathArray(model: QueryDocumentSnapshot))
            
            //MARK: - Настройка отображения элементов
            self.popupView.backgroundColor = .white
            self.popupView.layer.cornerRadius = 20
            
            self.nameModelLabel.numberOfLines = 0
            self.nameModelLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            self.nameModelLabel.text = FireBaseManager.shared.getModelName(model: QueryDocumentSnapshot)
            
            self.adressModelLabel.numberOfLines = 0
            self.adressModelLabel.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
            self.adressModelLabel.text = FireBaseManager.shared.getModelAdress(model: QueryDocumentSnapshot)
            
            self.moveToButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
            self.moveToButton.setTitle("Узнать больше", for: .normal)
            self.moveToButton.layer.cornerRadius = 10
            self.moveToButton.setTitleColor(.white, for: .normal)
            self.moveToButton.addTarget(self, action: #selector(self.moveToButtonPressed), for: .touchUpInside)
            
            self.model = QueryDocumentSnapshot
            
            //достаю попап
            UIView.animate(withDuration: 0.2) {
                self.popupView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()}
                self.view.layoutIfNeeded()}
        }
        NSLog("Did tap a normal marker")
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //скрываю попап
        UIView.animate(withDuration: 0.2) {
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
            $0.top.equalTo(nameModelLabel).inset(40)
        }
        
        moveToButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressModelLabel).inset(50)
            $0.height.equalTo(50)
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
    
}
