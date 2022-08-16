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
    var models: [QueryDocumentSnapshot] = []
    var model: QueryDocumentSnapshot?
    var coordinatesArray: [[Double]] = []
    var markerArray: [GMSMarker] = []
    
    lazy var forMapView = UIView()
    lazy var popupView = UIView()
    var nameModel = UILabel()
    var adressModel = UILabel()
    var moveToButton = UIButton()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        if models.isEmpty {
            loadView()
        }
        view.layoutSubviews()
        self.tabBarController?.delegate = self
        
        //View for googleMaps
        forMapView.frame = view.frame
        
        view.addSubview(forMapView)
        view.addSubview(popupView)
        popupView.addSubview(nameModel)
        popupView.addSubview(adressModel)
        popupView.addSubview(moveToButton)
        
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 20
        
        
        
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
            
            //Создаю точки для проверки работы кластеров

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
        // center the map on tapped marker
        mapView.animate(toLocation: marker.position)
        // check if a cluster icon was tapped
        if marker.userData is GMUCluster {
            // zoom in on tapped cluster
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            NSLog("Did tap cluster")
            return true
        }
        print(FireBaseManager.shared.getNameByCoordinate(models: models, latitude: marker.position.latitude))
        FireBaseManager.shared.getModelByCoordinate(collection: "\(FireBaseCollectionsEnum.attraction)", latitude: marker.position.latitude) { QueryDocumentSnapshot in
            print(FireBaseManager.shared.getImagesPathArray(model: QueryDocumentSnapshot))
            
            self.nameModel.numberOfLines = 0
            self.nameModel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            self.nameModel.text = FireBaseManager.shared.getModelName(model: QueryDocumentSnapshot)
            
            self.adressModel.numberOfLines = 0
            self.adressModel.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
            self.adressModel.text = FireBaseManager.shared.getModelAdress(model: QueryDocumentSnapshot)
            
            self.moveToButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
            self.moveToButton.setTitle("Узнать больше", for: .normal)
            self.moveToButton.layer.cornerRadius = 10
            self.moveToButton.setTitleColor(.white, for: .normal)
            self.moveToButton.addTarget(self, action: #selector(self.moveToButtonPressed), for: .touchUpInside)
            
            self.model = QueryDocumentSnapshot
            
            //достаю попап
            UIView.animate(withDuration: 0.5) {
                self.popupView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()}
                self.view.layoutIfNeeded()}
        }
        NSLog("Did tap a normal marker")
        return false
    }
    
    func showModelOnMap(coordinates: [Double]) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinates[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinates[FirebaseCoordinateEnum.longtitude.rawValue], zoom: 10)
        self.mapView = GMSMapView.map(withFrame: self.forMapView.frame, camera: camera)
        self.forMapView.addSubview(self.mapView)
        
        let position = CLLocationCoordinate2D(latitude: coordinates[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinates[FirebaseCoordinateEnum.longtitude.rawValue])
        let marker = GMSMarker(position: position)
        
        self.mapView.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //скрываю попап
        UIView.animate(withDuration: 0.5) {
            self.popupView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(250)}
            self.view.layoutIfNeeded()}
    }
    
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
        
        nameModel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
        }
        
        adressModel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(nameModel).inset(40)
        }
        
        moveToButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressModel).inset(50)
            $0.height.equalTo(50)
        }
        super.updateViewConstraints()
    }
    
    @objc private func moveToButtonPressed() {
        let modelViewController = ModelViewController()
                    modelViewController.model = model
        
                    self.navigationController?.pushViewController(modelViewController, animated: true)
        print("LOL")
    }
    
}
