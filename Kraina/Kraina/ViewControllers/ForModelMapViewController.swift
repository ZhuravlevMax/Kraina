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
import SPLarkController
import Firebase
import FloatingPanel

class ForModelMapViewController: UIViewController,
                                 GMSMapViewDelegate,
                                 ModelMapDelegate,
                                 FloatingPanelControllerDelegate {
    
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
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
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
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        button.setTitle("Построить маршрут", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(ForModelMapViewController.self,
                         action: #selector(moveToButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()
    
    private lazy var forShadowView: UIView = {
        let view = UIView()
        //view.backgroundColor = .gray
        
        return view
    }()
    
    private lazy var fpc: FloatingPanelController = {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        return fpc
    }()
    
    private lazy var appearance: SurfaceAppearance = {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 15
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        return appearance
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        view.layoutSubviews()
        
        //MARK: - Добавление элементов на экран
        view.addSubview(forMapView)
        view.addSubview(popupView)
        view.addSubview(forShadowView)
        popupView.addSubview(nameModel)
        popupView.addSubview(adressModel)
        popupView.addSubview(moveToButton)
        
        guard let modelUnwrapped = model else { return }
        coordinates = FireBaseManager.shared.getCoordinatesArray(model: modelUnwrapped)
        nameModel.text = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelName(model: modelUnwrapped) : FireBaseManager.shared.getModelNameEn(model: modelUnwrapped)
        adressModel.text = Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelAdress(model: modelUnwrapped) : FireBaseManager.shared.getModelAdressEn(model: modelUnwrapped)
        
        //MARK: - Работа с googleMaps
        //Добавляю карту на view
        let camera = GMSCameraPosition.camera(withLatitude: coordinates[FirebaseCoordinateEnum.latitude.rawValue],
                                              longitude: coordinates[FirebaseCoordinateEnum.longtitude.rawValue],
                                              zoom: 13)
        self.mapView = GMSMapView.map(withFrame: self.forMapView.frame, camera: camera)
        
        if traitCollection.userInterfaceStyle == .dark {
            do {
                        // Set the map style by passing the URL of the local file.
                        if let styleURL = Bundle.main.url(forResource: "styleDark", withExtension: "json") {
                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)

                        } else {
                            NSLog("Unable to find style.json")
                        }
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }
        } else {
            do {
                        // Set the map style by passing the URL of the local file.
                        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)

                        } else {
                            NSLog("Unable to find style.json")
                        }
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }
        }
        
        self.forMapView.addSubview(self.mapView)
        
        self.mapView.delegate = self
        
        addMarker(mapView: mapView,
                  latData: coordinates[FirebaseCoordinateEnum.latitude.rawValue],
                  lonData: coordinates[FirebaseCoordinateEnum.longtitude.rawValue])
        
        //MARK: - Добавляю кнопку в navigation bar
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        //MARK: - Работа с всплывающим попапом
        fpc.surfaceView.appearance = appearance
        fpc.layout = MyFloatingPanelLayout()
        //Создание попапа на popupVC
        let popupVC = PopupForModelMapViewController()
        guard let model = model else {return}
        popupVC.setModel(setModel: model)
        popupVC.forModelMapVC = self
        fpc.set(contentViewController: popupVC)
        fpc.addPanel(toParent: self)
        fpc.move(to: .half, animated: true)
        
        updateViewConstraints()
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
    
    //MARK: - контсрейты для элементов
    override func updateViewConstraints() {
        
        //для view для googleMaps
        forMapView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
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
    private func addMarker(mapView: GMSMapView,
                           latData: Double,
                           lonData: Double) {
        //MARK: - работа с маркером
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latData,
                                                 longitude: lonData)
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
    //MARK: - Метод по нажатию на кластер или маркер
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // center the map on tapped marker
        mapView.animate(toLocation: marker.position)
        
        FireBaseManager.shared.getModelByCoordinate(collection: "\(FireBaseCollectionsEnum.attraction)",
                                                    latitude: marker.position.latitude) { [weak self] QueryDocumentSnapshot in
            NSLog("Did tap a normal marker")
            
            guard let self = self else {return}
            self.fpc.move(to: .half, animated: true)
        }
        return false
    }
    
    //MARK: - Метод при нажатии на карту
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
    
    //MARK: - действие при нажатии на кнопку moveToButton
    @objc private func moveToButtonPressed() {
        doNavigationAlert()
    }
    
    //MARK: - Метод для получения модели из других VC
    func setModel(modelToSet: QueryDocumentSnapshot) {
        model = modelToSet
    }
    
    //MARK: - Метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
    }
    
    // MARK: - Метод для работы с навигацией google maps
    func showGoogleApp(coordinates: [Double]) {
        guard let urlApp = URL(string:"comgooglemaps://"),
              let urlDestination = URL(string: "comgooglemaps://?center=\(coordinates[FirebaseCoordinateEnum.latitude.rawValue]),\(coordinates[FirebaseCoordinateEnum.longtitude.rawValue])&saddr=&daddr=\(coordinates[FirebaseCoordinateEnum.latitude.rawValue]),\(coordinates[FirebaseCoordinateEnum.longtitude.rawValue])&zoom=14&views=traffic"),
              let browserUrl = URL(string: "https://www.google.co.in/maps/dir/"),
              let browserUrlDestination = URL(string: "https://www.google.co.in/maps/dir/?center=\(coordinates[FirebaseCoordinateEnum.latitude.rawValue]),\(coordinates[FirebaseCoordinateEnum.longtitude.rawValue])&saddr=&daddr=\(coordinates[FirebaseCoordinateEnum.latitude.rawValue]),\(coordinates[FirebaseCoordinateEnum.longtitude.rawValue])&zoom=14&views=traffic") else {return}
        
        if (UIApplication.shared.canOpenURL(urlApp)) {
            UIApplication.shared.open(urlDestination)
        } else if (UIApplication.shared.canOpenURL(browserUrl)) {
            UIApplication.shared.open(browserUrlDestination)
        }
    }
    
    //MARK: - Метод для работы с навигацией yandex navi
    func showYandexApp(coordinates: [Double]) {
        guard let urlApp = URL(string:"yandexnavi://"),
              let urlDestination = URL(string: "yandexnavi://build_route_on_map?lat_to=\(coordinates[FirebaseCoordinateEnum.latitude.rawValue])&lon_to=\(coordinates[FirebaseCoordinateEnum.longtitude.rawValue])"),
              let browserUrlDestination = URL(string: "https://itunes.apple.com/ru/app/yandex.navigator/id474500851") else {return}
        
        if (UIApplication.shared.canOpenURL(urlApp)) {
            UIApplication.shared.open(urlDestination)
        } else {
            UIApplication.shared.open(browserUrlDestination)
        }
    }
    
    //MARK: - AlertController для выбора навигатора
    func doNavigationAlert() {
        dismiss(animated: true)
        let navigationAlert = UIAlertController(title: NSLocalizedString("ForModelMapViewController.doNavigationAlert.navigationAlert.title", comment: ""), message: NSLocalizedString("ForModelMapViewController.doNavigationAlert.navigationAlert.message", comment: ""), preferredStyle: .actionSheet)
        let google = UIAlertAction(title: "Google Maps", style: .default) { [weak self]_ in
            guard let self = self else {return}
            self.showGoogleApp(coordinates: self.coordinates)
        }
        let yandex = UIAlertAction(title: "Yandex Navi", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.showYandexApp(coordinates: self.coordinates)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("ForModelMapViewController.doNavigationAlert.cancelButton.title", comment: ""), style: .cancel)
        navigationAlert.addAction(google)
        navigationAlert.addAction(yandex)
        navigationAlert.addAction(cancel)
        self.present(navigationAlert, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if traitCollection.userInterfaceStyle == .dark {
            do {
                        // Set the map style by passing the URL of the local file.
                        if let styleURL = Bundle.main.url(forResource: "styleDark", withExtension: "json") {
                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)

                        } else {
                            NSLog("Unable to find style.json")
                        }
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }
        } else {
            do {
                        // Set the map style by passing the URL of the local file.
                        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)

                        } else {
                            NSLog("Unable to find style.json")
                        }
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }
        }
    }
}








