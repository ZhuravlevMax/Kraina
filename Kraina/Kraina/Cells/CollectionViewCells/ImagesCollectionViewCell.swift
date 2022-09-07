//
//  ImagesCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 31.08.22.
//

import UIKit
import Firebase
import Kingfisher

class ImagesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Создание переменных
    static let key = "ImagesCollectionViewCell"
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        //imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //MARK: - Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        contentView.addSubview(mainView)
        mainView.addSubview(mainImageView)
        
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
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func setImage(image: String) {
        //self.mainImageView.load(url: image)
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: (URL(string: image)), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }
}
