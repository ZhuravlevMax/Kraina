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

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    var models: [QueryDocumentSnapshot] = []
    var coordinatesArray: [[Double]] = []
    var markerArray: [GMSMarker] = []
    lazy var forMapView = UIView()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        //View for googleMaps
        forMapView.frame = view.frame
        view.addSubview(forMapView)
        
        DispatchQueue.main.async {
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
        }

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
        FireBaseManager.shared.getModelByCoordinate(collection: "\(FireBaseCollectionsEnum.castles)", latitude: marker.position.latitude) { QueryDocumentSnapshot in
            print(FireBaseManager.shared.getImagesPathArray(model: QueryDocumentSnapshot))
        }
        NSLog("Did tap a normal marker")
        return false
    }
    
    override func updateViewConstraints() {
        
        //для view для googleMaps
        forMapView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        super.updateViewConstraints()
    }
}
