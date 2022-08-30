//
//  MainCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 30.08.22.
//

import UIKit
import Firebase

class TypeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Создание переменных
    static let key = "MainCollectionViewCell"
    
    //MARK: - Создание элементов UI
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var nameModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    //MARK: - Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        contentView.addSubview(mainImageView)
        contentView.addSubview(shadowView)
        shadowView.addSubview(nameModelLabel)
        
       backgroundColor = .white
//        mainView.layer.masksToBounds = false
//        mainView.layer.shadowOpacity = 0.3
//        mainView.layer.cornerRadius = 6
//        mainView.layer.shadowOffset = CGSize(width: 2, height: 3)
//        mainView.layer.shadowColor = UIColor.black.cgColor
//        
//        mainImageView.layer.cornerRadius = 6
//        mainImageView.layer.masksToBounds = true
//        
        shadowView.layer.cornerRadius = 6
        shadowView.layer.masksToBounds = true
        shadowView.backgroundColor = .gray.withAlphaComponent(0.3)
        
        updateViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        
        mainImageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        nameModelLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(20)
        }
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        guard let imageURL = FireBaseManager.shared.getImagesPathArray(model: model).first else {return}
        self.mainImageView.load(url: imageURL)
        
        
    }
    
}
