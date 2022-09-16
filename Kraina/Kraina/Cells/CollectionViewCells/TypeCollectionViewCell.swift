//
//  MainCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 30.08.22.
//

import UIKit
import Firebase
import Kingfisher

class TypeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Создание переменных
    static let key = "TypeCollectionViewCell"
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var nameModelLabel: UILabel = {
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
                                       height: contentView.frame.height/2.5)
        
        shadowView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = false
        contentView.backgroundColor = .clear
        
        shadowView.addGradientBackground(firstColor: .black.withAlphaComponent(0.7),
                                         secondColor: .clear)
        updateViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        mainImageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview().inset(10)
        }
        
        shadowView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview().inset(10)
        }
        
        nameModelLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(20)
            
        }
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        guard let imageURL = FireBaseManager.shared.getImagesPathArray(model: model).first else {return}
        //self.mainImageView.load(url: imageURL)
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: (URL(string: imageURL)), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }
    
    //MARK: - Метод для передачи объекта из другого VC и работы с UI
    func configure(with model: QueryDocumentSnapshot) {
        setImage(model: model)
        nameModelLabel.text = showLocalizedModelName(for: model)
 
        contentView.layer.cornerRadius = 6
    }
    
}
