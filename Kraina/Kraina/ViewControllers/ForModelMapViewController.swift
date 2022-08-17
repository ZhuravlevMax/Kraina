//
//  ForModelMapViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 16.08.22.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import SnapKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class ForModelMapViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    var model: QueryDocumentSnapshot?
    var coordinate: [Double]?
    
    lazy var forMapView = UIView()
    lazy var popupView = UIView()
    var nameModel = UILabel()
    var adressModel = UILabel()
    var moveToButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layoutSubviews()
        //View for googleMaps
        forMapView.frame = view.frame
        
        view.addSubview(forMapView)
        view.addSubview(popupView)
        popupView.addSubview(nameModel)
        popupView.addSubview(adressModel)
        popupView.addSubview(moveToButton)
        
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 20
        
        
        guard let coordinate = coordinate,
        let modelUnwrapped = model else { return }
        
        nameModel.numberOfLines = 0
        nameModel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameModel.text = FireBaseManager.shared.getModelName(model: modelUnwrapped)
        
        adressModel.numberOfLines = 0
        adressModel.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
        adressModel.text = FireBaseManager.shared.getModelAdress(model: modelUnwrapped)
        
        moveToButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        moveToButton.setTitle("Построить маршрут", for: .normal)
        moveToButton.layer.cornerRadius = 10
        moveToButton.setTitleColor(.white, for: .normal)
        moveToButton.addTarget(self, action: #selector(moveToButtonPressed), for: .touchUpInside)
        
        //MARK: - Работа с googleMaps
        //Добавляю карту на view
        let camera = GMSCameraPosition.camera(withLatitude: coordinate[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinate[FirebaseCoordinateEnum.longtitude.rawValue], zoom: 15)
        self.mapView = GMSMapView.map(withFrame: self.forMapView.frame, camera: camera)
        self.forMapView.addSubview(self.mapView)
        
        self.mapView.delegate = self
        
        addMarker(mapView: mapView, latData: coordinate[FirebaseCoordinateEnum.latitude.rawValue], lonData: coordinate[FirebaseCoordinateEnum.longtitude.rawValue])
        
        updateViewConstraints()
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
    
    func addMarker(mapView: GMSMapView, latData: Double, lonData: Double) {
        //MARK: - работа с маркером
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latData, longitude: lonData)
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
    //MARK: - Функция по нажатию на кластер или маркер
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // center the map on tapped marker
        mapView.animate(toLocation: marker.position)
        
        FireBaseManager.shared.getModelByCoordinate(collection: "\(FireBaseCollectionsEnum.attraction)", latitude: marker.position.latitude) { QueryDocumentSnapshot in
            //print(FireBaseManager.shared.getImagesPathArray(model: QueryDocumentSnapshot))
            
            //достаю попап
            UIView.animate(withDuration: 0.2) {
                self.popupView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()}
                self.view.layoutIfNeeded()}
            
            NSLog("Did tap a normal marker")
            
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //скрываю попап
        UIView.animate(withDuration: 0.2) {
            self.popupView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(250)}
            self.view.layoutIfNeeded()}
    }
    
    @objc private func moveToButtonPressed() {
        print("LOL")
    }
}







