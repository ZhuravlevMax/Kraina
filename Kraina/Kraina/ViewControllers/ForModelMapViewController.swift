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
    
    //MARK: - Создание переменных
    private var mapView: GMSMapView!
    private var model: QueryDocumentSnapshot?
    private var coordinates: [Double] = []
    
    //MARK: - Cоздание элементов UI
    private lazy var forMapView: UIView = {
        let viewForMap = UIView()
        viewForMap.frame = view.frame
        return viewForMap
    }()
    
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var nameModel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var adressModel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
        return label
    }()
    
    private var moveToButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        button.setTitle("Построить маршрут", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(moveToButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.layoutSubviews()
        
        //MARK: - Добавление элементов на экран
        view.addSubview(forMapView)
        view.addSubview(popupView)
        popupView.addSubview(nameModel)
        popupView.addSubview(adressModel)
        popupView.addSubview(moveToButton)
        
        guard let modelUnwrapped = model else { return }
        coordinates = FireBaseManager.shared.getCoordinatesArray(model: modelUnwrapped)
        nameModel.text = FireBaseManager.shared.getModelName(model: modelUnwrapped)
        adressModel.text = FireBaseManager.shared.getModelAdress(model: modelUnwrapped)

        //MARK: - Работа с googleMaps
        //Добавляю карту на view
        let camera = GMSCameraPosition.camera(withLatitude: coordinates[FirebaseCoordinateEnum.latitude.rawValue], longitude: coordinates[FirebaseCoordinateEnum.longtitude.rawValue], zoom: 15)
        self.mapView = GMSMapView.map(withFrame: self.forMapView.frame, camera: camera)
        self.forMapView.addSubview(self.mapView)
        
        self.mapView.delegate = self
        
        addMarker(mapView: mapView, latData: coordinates[FirebaseCoordinateEnum.latitude.rawValue], lonData: coordinates[FirebaseCoordinateEnum.longtitude.rawValue])
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        updateViewConstraints()
    }
    
    //MARK: - контсрейты для элементов
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
    
    //MARK: - Метод для добавления маркера на карту
    private func addMarker(mapView: GMSMapView, latData: Double, lonData: Double) {
        //MARK: - работа с маркером
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latData, longitude: lonData)
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
    //MARK: - Метод по нажатию на кластер или маркер
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
    
    //MARK: - Метод при нажатии на карту
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //скрываю попап
        UIView.animate(withDuration: 0.2) {
            self.popupView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(250)}
            self.view.layoutIfNeeded()}
    }
    
    //MARK: - действие при нажатии на кнопку moveToButton
    @objc private func moveToButtonPressed() {
        print("LOL")
    }
    
    //MARK: - Метод для получения модели из других VC
    func setModel(modelToSet: QueryDocumentSnapshot) {
        model = modelToSet
    }
    
    //MARK: - метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
    }
}







