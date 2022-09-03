//
//  ModelCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 23.08.22.
//

import UIKit
import Firebase

class ModelCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Создание переменных
    static let key = "modelCell"
    private var modelType: String?
    private var models: [QueryDocumentSnapshot]?
    weak var changeTypeDelegate: ChangeTypeDelegate?
    override var isSelected: Bool {
        didSet {
            setSelectedAttribute(isSelected: isSelected)
        }
    }
    
    //MARK: - Создание элементов UI
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var modelName: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return nameLabel
    }()
    
    //MARK: - Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(modelName)
        
        updateViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        iconImageView.snp.makeConstraints {
//            $0.left.top.equalToSuperview().inset(10)
//            $0.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        
        modelName.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(10)
            $0.top.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            //$0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Метод для получения значений из других VC
    func setVar(setText: String, setType: String, image: UIImage, modelsSet: [QueryDocumentSnapshot]) {
        modelName.text = setText
        modelType = setType
        iconImageView.image = image
        models = modelsSet
        
    }
    
    //MARK: - Метод при выборе ячейки
    func setSelectedAttribute(isSelected: Bool) {

        self.backgroundColor = isSelected ? AppColorsEnum.mainAppUIColor : .white
        guard let models = models else {return}
        var modelsToMapArray: [QueryDocumentSnapshot] = []
        if modelType == "\(FireBaseTypeEnum.all)" {
           modelsToMapArray = models
        } else {
            modelsToMapArray = models.filter({
                self.modelType == FireBaseManager.shared.getModelType(model: $0)
            })
        }
        
        
        
        guard let changeTypeDelegate = self.changeTypeDelegate else {return}
        changeTypeDelegate.changeMarkerType(modelsSet: modelsToMapArray)
        
        //вибрация по нажатию
        let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
    }
}
