//
//  SearchTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 26.08.22.
//

import UIKit
import Firebase

class SearchTableViewCell: UITableViewCell {
    
    //MARK: - Создание переменных
    static let key = "searchTableViewCell"
    
    //MARK: - Создание элементов UI
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var nameModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return nameLabel
    }()
    
    lazy var typeModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameModelLabel)
        contentView.addSubview(typeModelLabel)
        
        
        updateViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        nameModelLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(10)
            $0.top.equalToSuperview().inset(10)
        }
        
        typeModelLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
