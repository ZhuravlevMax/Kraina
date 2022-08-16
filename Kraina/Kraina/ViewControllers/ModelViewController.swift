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
    var modelDescription = UILabel()
    
    private lazy var modelScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = view.frame
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()

    //Сюда передаю нужную модель/достопримечательность
    var model: QueryDocumentSnapshot?

//    let modelMainTableView: UITableView = {
//        let table = UITableView()
//        return table
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        modelScrollView.insetsLayoutMarginsFromSafeArea = false
        modelScrollView.contentInsetAdjustmentBehavior = .never
        view.layoutSubviews()
        
        showOnMapButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        showOnMapButton.setTitle("Посмотреть на карте", for: .normal)
        showOnMapButton.layer.cornerRadius = 10
        showOnMapButton.setTitleColor(.white, for: .normal)
        showOnMapButton.addTarget(self, action: #selector(showOnMapButtonPressed), for: .touchUpInside)

        
        guard let model = model else {return}
        //title = FireBaseManager.shared.getModelName(model: model)
        
//        modelMainTableView.delegate = self
//        modelMainTableView.dataSource = self
//        modelMainTableView.register(ModelMainTableViewCell.self, forCellReuseIdentifier: ModelMainTableViewCell.identifier)
        
        //MARK: - добавление элементов UI на View
        view.addSubview(modelScrollView)
        modelScrollView.addSubview(contentView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(coordinatesLabel)
        contentView.addSubview(showOnMapButton)
        contentView.addSubview(modelDescription)
        
        setImage(model: model)
        //self.configureImageView()
        setImageViewConstraite()

        initialize()
        
    }
    
    @objc private func showOnMapButtonPressed() {
        print("LOL")
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
    
//    func configureImageView() {
//        mainImageView.clipsToBounds = true
//    }
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
            
            self.modelDescription.numberOfLines = 0
            self.modelDescription.text = "\(FireBaseManager.shared.getModelDescription(model: model))"
            
            

            
            
            
        }
        
        modelScrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
            //$0.width.equalToSuperview()
            $0.bottom.equalToSuperview()

            }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()

            }
        
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(view)
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
            $0.top.equalTo(coordinatesLabel).inset(30)
            $0.height.equalTo(50)
        }

        modelDescription.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(showOnMapButton).inset(80)
            $0.bottom.equalToSuperview().offset(-50)
        }
                
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        let imagesUrlArray = FireBaseManager.shared.getImagesPathArray(model: model)
        guard let imageURL = imagesUrlArray.first else {return}
            self.mainImageView.load(url: imageURL)
        mainImageView.contentMode = .scaleAspectFill

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

