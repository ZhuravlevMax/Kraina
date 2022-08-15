//
//  ModelMainTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.08.22.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class ModelMainTableViewCell: UITableViewCell {
    
    static let identifier = "ModelMainTableViewCell"
    
    var buttonTapCallback: () -> ()  = { }
    
    //MARK: - Создание переменных
    var mainImageView = UIImageView()
    var nameLabel = UILabel()
    var adressLabel = UILabel()
    var coordinatesLabel = UILabel()
    var showOnMapButton = UIButton(type: .system)

    //Сюда передаю нужную модель/достопримечательность
    var model: QueryDocumentSnapshot?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.mainImageView)
        
        //self.showOnMapButton.addTarget(self, action: #selector(self.showOnMapButtonPressed), for: .touchUpInside)
        DispatchQueue.main.async {
            
            //MARK: - добавление элементов UI на View
            self.contentView.addSubview(self.nameLabel)
            self.contentView.addSubview(self.adressLabel)
            self.contentView.addSubview(self.coordinatesLabel)
            self.contentView.addSubview(self.showOnMapButton)
            
            self.configureImageView()
            self.setImageViewConstraite()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureImageView() {
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
            $0.bottom.equalToSuperview().inset(200)
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
        buttonTapCallback()
    }
    
//    @objc func buttonAction(_ sender: UIButton) {
//       //Call your closure here
//               buttonPressed()
//           }
    
}
