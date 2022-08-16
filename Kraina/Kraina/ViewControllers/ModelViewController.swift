//
//  ModelViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.08.22.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class ModelViewController: UIViewController {
    
    //MARK: - Создание переменных
    var mainImageView = UIImageView()
    var nameLabel = UILabel()
    var adressLabel = UILabel()
    var coordinatesLabel = UILabel()
    var showOnMapButton = UIButton(type: .system)

    //Сюда передаю нужную модель/достопримечательность
    var model: QueryDocumentSnapshot?

//    let modelMainTableView: UITableView = {
//        let table = UITableView()
//        return table
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layoutSubviews()
        
        guard let model = model else {return}
        //title = FireBaseManager.shared.getModelName(model: model)
        
//        modelMainTableView.delegate = self
//        modelMainTableView.dataSource = self
//        modelMainTableView.register(ModelMainTableViewCell.self, forCellReuseIdentifier: ModelMainTableViewCell.identifier)
        
        //MARK: - добавление элементов UI на View
        self.view.addSubview(self.mainImageView)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.adressLabel)
        self.view.addSubview(self.coordinatesLabel)
        self.view.addSubview(self.showOnMapButton)
        
        self.setImage(model: model)
        self.configureImageView()
        self.setImageViewConstraite()
        
        
        initialize()
        
    }
    
    
    
    private func initialize() {
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
//        modelMainTableView.estimatedRowHeight = 85
//        modelMainTableView.frame = view.bounds
//        modelMainTableView.rowHeight = UITableView.automaticDimension
//        modelMainTableView.separatorStyle = .none
//        view.addSubview(modelMainTableView)
    }
    
    func configureImageView() {
        
        mainImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        mainImageView.clipsToBounds = true
    }
    //MARK: - Работа с внешним видом элементов
    func setImageViewConstraite() {
        
        
        DispatchQueue.main.async {
            guard let model = self.model else {return}
            self.nameLabel.text = FireBaseManager.shared.getModelName(model: model)
            self.nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            self.adressLabel.text = FireBaseManager.shared.getModelAdress(model: model)
            self.adressLabel.font = UIFont.systemFont(ofSize: 11, weight: .ultraLight)
            self.adressLabel.numberOfLines = 0
            
            self.coordinatesLabel.text = "\(FireBaseManager.shared.getCoordinatesArray(model: model)[FirebaseCoordinateEnum.latitude.rawValue]), \(FireBaseManager.shared.getCoordinatesArray(model: model)[FirebaseCoordinateEnum.longtitude.rawValue])"
            self.adressLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
            
            self.showOnMapButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 35/255, alpha: 1)
            self.showOnMapButton.setTitleColor(.white, for: .normal)
            self.showOnMapButton.setTitle("Показать на карте", for: .normal)
            self.showOnMapButton.layer.cornerRadius = 10
            self.showOnMapButton.addTarget(self, action: #selector(self.showOnMapButtonPressed), for: .touchUpInside)
            
            
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(300)

            }
        
        nameLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(340)
        }
        
        adressLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel).inset(30)
        }
        
        coordinatesLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressLabel).inset(30)
        }
        
        showOnMapButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(coordinatesLabel).inset(50)
            $0.height.equalTo(50)
            
        }
                
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        let imagesUrlArray = FireBaseManager.shared.getImagesPathArray(model: model)
        guard let imageURL = imagesUrlArray.first else {return}
            self.mainImageView.load(url: imageURL)

    }
    
    @objc private func showOnMapButtonPressed() {
        print("FAFA")
    }

}

//extension ModelViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if let tableCell = modelMainTableView.dequeueReusableCell(withIdentifier: ModelMainTableViewCell.identifier, for: indexPath) as? ModelMainTableViewCell {
//            tableCell.model = model
//            tableCell.buttonTapCallback = {
//                        print("Hi")
//                    }
//            if let modelUnwrapped = model {
//                tableCell.setImage(model: modelUnwrapped)
//                
//            }
//            
//            return tableCell
//        }
//        
//        return UITableViewCell()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//}

