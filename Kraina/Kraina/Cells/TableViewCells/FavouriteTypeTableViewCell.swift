//
//  FavouriteTypeTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 28.08.22.
//

import UIKit
import Firebase
import Kingfisher

class FavouriteTypeTableViewCell: UITableViewCell {
    
    //MARK: - Создание переменных
    static let key = "favouriteTypeTableViewCell"
    weak var oneTypeItemsVC: OneTypeVCDelegate?
    var model: QueryDocumentSnapshot?
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        view.layer.cornerRadius = 6
        view.dropShadow()
        return view
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
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
    
    private lazy var nameModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16,
                                           weight: .bold)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    lazy var addToFavoriteButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(systemName: "bookmark"),
                        for: .normal)
        button.setTitleColor(.white,
                             for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self,
                         action: #selector(addToFavoriteButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.contentView.frame = self.bounds
        
        infoView.frame = contentView.frame
        infoView.frame.size = CGSize(width: contentView.frame.width,
                                     height: contentView.frame.height/2.5)
        
        infoView.addGradientBackground(firstColor: .black.withAlphaComponent(0.7),
                                       secondColor: .clear)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - Добавление элементов на экран
        contentView.addSubview(mainView)
        mainView.addSubview(mainImageView)
        mainView.addSubview(infoView)
        infoView.addSubview(nameModelLabel)
        //infoView.addSubview(addToFavoriteButton)
        
        backgroundColor = .clear
        
        updateViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
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
            $0.right.equalToSuperview().inset(50)
            $0.top.equalToSuperview().inset(20)
        }
        
//        addToFavoriteButton.snp.makeConstraints {
//            $0.right.equalToSuperview().inset(20)
//            $0.top.equalToSuperview().inset(20)
//        }
    }
    func setVar(nameModel: String) {
        nameModelLabel.text = nameModel
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        guard let imageURL = FireBaseManager.shared.getImagesPathArray(model: model).first else {return}
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: (URL(string: imageURL)),
                                  placeholder: nil,
                                  options: [.transition(.fade(0.7))],
                                  progressBlock: nil)
    }
    
    //MARK: - метод для кнопки добавить в избранное addToFavoriteButton
    @objc private func addToFavoriteButtonPressed() {
        guard let model = model else {return}

        oneTypeItemsVC?.addToFavouriteFromCell(model: model)
    }
    
}
