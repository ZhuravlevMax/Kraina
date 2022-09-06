//
//  FavouriteTypeTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 28.08.22.
//

import UIKit
import Firebase

class FavouriteTypeTableViewCell: UITableViewCell {
    
    //MARK: - Создание переменных
    static let key = "favouriteTypeTableViewCell"
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.dropShadow()
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var nameModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    override func layoutIfNeeded() {
            super.layoutIfNeeded()
        self.contentView.frame = self.bounds
        
        infoView.frame = contentView.frame

        infoView.addGradientBackground(firstColor: .black.withAlphaComponent(0.4),
                                       secondColor: .clear)

            //gradientLayer.frame = bounds
        }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - Добавление элементов на экран
        contentView.addSubview(mainView)
        mainView.addSubview(mainImageView)
        mainView.addSubview(infoView)
        infoView.addSubview(nameModelLabel)
        
        backgroundColor = .clear

        updateViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        mainView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview().inset(10)
        }
        
        mainImageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        infoView.snp.makeConstraints {
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
