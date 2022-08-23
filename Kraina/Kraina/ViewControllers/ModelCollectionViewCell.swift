//
//  ModelCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 23.08.22.
//

import UIKit

class ModelCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLoginLable: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return nameLabel
    }()
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
    
    static let key = "modelCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLoginLable)
        titleLoginLable.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        

    }
    
    func setLabel(setText: String) {
        titleLoginLable.text = setText
    }
}
