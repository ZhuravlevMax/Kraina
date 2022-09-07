//
//  FavoriteCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 28.08.22.
//

import UIKit
import Firebase

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Создание переменных
    static let key = "favoriteCollectionViewCell"
    private var modelType: String?
    private var models: [QueryDocumentSnapshot]?
    weak var changeTypeDelegate: ChangeTypeDelegate?
    override var isSelected: Bool {
        didSet {
            setSelectedAttribute(isSelected: isSelected)
        }
    }
    
    //MARK: - Создание элементов UI
    
    private lazy var typeNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return nameLabel
    }()
    
    private lazy var countLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = .gray
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return nameLabel
    }()
    
    //MARK: - Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(typeNameLabel)
        contentView.addSubview(countLabel)
        
        updateViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        
        typeNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
        }
    }
    
    //MARK: - Метод для получения значений из других VC
    func setVar(setText: String, count: Int) {
        typeNameLabel.text = setText.uppercased()
        countLabel.text = String(count)
    }
    //MARK: - Метод при выборе ячейки
    func setSelectedAttribute(isSelected: Bool) {
        
        guard let models = models else {return}
        
        let modelsToMapArray = models.filter({
            self.modelType == FireBaseManager.shared.getModelType(model: $0)
        })
        
        guard let changeTypeDelegate = self.changeTypeDelegate else {return}
        changeTypeDelegate.changeMarkerType(modelsSet: modelsToMapArray)
    }
}
