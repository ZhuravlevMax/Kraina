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
        
        let camera = GMSCameraPosition.camera(withLatitude: 54.029, longitude: 27.597, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: forMapView.frame, camera: camera)
        forMapView.addSubview(mapView)
        
        mapView.delegate = self
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algoritm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algoritm, renderer: renderer)
        clusterManager.setMapDelegate(self)

    }
    
}
