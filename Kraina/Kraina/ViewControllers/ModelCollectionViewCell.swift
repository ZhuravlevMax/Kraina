//
//  ModelCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 23.08.22.
//

import UIKit
import Firebase

class ModelCollectionViewCell: UICollectionViewCell {
    
    static let key = "modelCell"
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var modelName: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        //nameLabel.textAlignment = .justified
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return nameLabel
    }()
    
    private var modelType: String?
    private var models: [QueryDocumentSnapshot]?
    
    var changeTypeDelegate: ChangeTypeDelegate?
    
    override var isSelected: Bool {
        didSet {
            setSelectedAttribute(isSelected: isSelected)
        }
    }
    
    func setSelectedAttribute(isSelected: Bool) {
        
        self.backgroundColor = isSelected ? AppColorsEnum.mainAppUIColor : .white
        var modelsToMapArray: [QueryDocumentSnapshot] = []
        guard let models = models else {return}
        
        models.forEach {
            var modelTypeFromDB = FireBaseManager.shared.getModelType(model: $0)
            if self.modelType == modelTypeFromDB {
 
                modelsToMapArray.append($0)
                
            }
            
        }
        guard let changeTypeDelegate = self.changeTypeDelegate else {return}
        
        changeTypeDelegate.changeMarkerType(modelsSet: modelsToMapArray)
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(modelName)
        
        iconImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(-10)
        }
        
        modelName.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(10)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(-10)
            //$0.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setVar(setText: String, setType: String, image: UIImage, modelsSet: [QueryDocumentSnapshot]) {
        modelName.text = setText
        modelType = setType
        iconImageView.image = image
        models = modelsSet
        
    }
    
    
}
