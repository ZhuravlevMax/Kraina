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
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
       // view.layer.masksToBounds = false
       // view.layer.shadowOpacity = 0.3
        //view.layer.cornerRadius = 6
//        view.layer.shadowOffset = CGSize(width: 2, height: 3)
//        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        //view.backgroundColor = .gray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
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
 
        contentView.addSubview(mainView)
        mainView.addSubview(mainImageView)
        mainView.addSubview(shadowView)
        shadowView.addSubview(nameModelLabel)

        mainView.dropShadow()
        mainView.layer.cornerRadius = 6
        shadowView.frame.size = CGSize(width: contentView.frame.width,
                                       height: contentView.frame.height)

        shadowView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = false
        contentView.backgroundColor = .clear
        
        shadowView.addGradientBackground(firstColor: .black.withAlphaComponent(0.5),
                                         secondColor: .clear)
        updateViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        mainImageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        nameModelLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
        }
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        guard let imageURL = FireBaseManager.shared.getImagesPathArray(model: model).first else {return}
        self.mainImageView.load(url: imageURL)
        
        
    }
    
}
