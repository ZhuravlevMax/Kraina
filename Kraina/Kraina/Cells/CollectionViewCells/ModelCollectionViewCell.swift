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
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "\(NameColorForThemesEnum.borderCGColor)")?.cgColor
        return view
    }()
    
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
        
        contentView.addSubview(mainView)
        mainView.addSubview(iconImageView)
        mainView.addSubview(modelName)
        
        updateViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
        mainView.snp.makeConstraints {
            
            $0.right.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        
        modelName.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(10)
            $0.top.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
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
        
        mainView.backgroundColor = isSelected ? UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)") : UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        guard let models = models else {return}
        var modelsToMapArray: [QueryDocumentSnapshot] = []
        if modelType == "\(FireBaseTypeEnum.all)" {
            modelsToMapArray = models
        } else {
            modelsToMapArray = models.filter({
                self.modelType == FireBaseManager.shared.getModelType(model: $0).lowercased()
            })
        }
        
        guard let changeTypeDelegate = self.changeTypeDelegate else {return}
        changeTypeDelegate.changeMarkerType(modelsSet: modelsToMapArray)
        
        //вибрация по нажатию
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
