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
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainView)
        mainView.addSubview(mainImageView)
        mainView.addSubview(infoView)
        
        backgroundColor = .clear
        mainView.layer.masksToBounds = false
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.cornerRadius = 6
        mainView.layer.shadowOffset = CGSize(width: 2, height: 3)
        mainView.layer.shadowColor = UIColor.black.cgColor
        
        mainImageView.layer.cornerRadius = 6
        mainImageView.layer.masksToBounds = true
        
        
        infoView.layer.cornerRadius = 6
        infoView.layer.masksToBounds = true
        infoView.backgroundColor = .gray.withAlphaComponent(0.3)



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
            $0.left.top.right.bottom.equalToSuperview().inset(20)
        }
        
        mainImageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        infoView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        guard let imageURL = FireBaseManager.shared.getImagesPathArray(model: model).first else {return}
        self.mainImageView.load(url: imageURL)
        
        
    }

    

}
