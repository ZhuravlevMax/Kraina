//
//  MapViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
//MARK: - Работа с Outlets
    @IBOutlet weak var forMapView: UIView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        //MARK: - Работа с googleMaps
        //Добавляю карту на view
        let camera = GMSCameraPosition.camera(withLatitude: 47.60, longitude: -122.33, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: forMapView.frame, camera: camera)
        forMapView.addSubview(mapView)
        
        mapView.delegate = self
        
        //Работа с кластерами
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algoritm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algoritm, renderer: renderer)
        clusterManager.setMapDelegate(self)
        
        //Создаю точки для проверки работы кластеров
        let position1 = CLLocationCoordinate2D(latitude: 47.60, longitude: -122.33)
        let marker1 = GMSMarker(position: position1)

        let position2 = CLLocationCoordinate2D(latitude: 47.60, longitude: -122.46)
        let marker2 = GMSMarker(position: position2)
        
        let position3 = CLLocationCoordinate2D(latitude: 47.60, longitude: -122.33)
        let marker3 = GMSMarker(position: position3)

        let position4 = CLLocationCoordinate2D(latitude: 47.60, longitude: -122.46)
        let marker4 = GMSMarker(position: position4)

        let markerArray = [marker1, marker2, marker3, marker4]
        //Добавляю точки в менеджер кластеров
        clusterManager.add(markerArray)
        
        clusterManager.cluster()

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

      NSLog("Did tap a normal marker")
      return false
    }

}
