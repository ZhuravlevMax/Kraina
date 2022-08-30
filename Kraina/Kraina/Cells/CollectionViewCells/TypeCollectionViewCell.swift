//
//  MainCollectionViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 30.08.22.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Создание переменных
    static let key = "MainCollectionViewCell"
    
    //MARK: - Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        
        updateViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViewConstraints() {
    }
    
}
