//
//  MainTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 30.08.22.
//

import UIKit
import Firebase

class MainTableViewCell: UITableViewCell {
    
    //MARK: - Создание переменных
    static let key = "MainTableViewCell"
    var models: [QueryDocumentSnapshot]?
    
    //MARK: - Создание элементов UI
     lazy var typeNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = "Example"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var showAllButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = .clear
        moveButton.setTitle("ВCE",
                            for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor( AppColorsEnum.mainAppUIColor,
                                  for: .normal)
        moveButton.addTarget(self, action: #selector(self.showAllButtonPressed),
                             for: .touchUpInside)
        return moveButton
    }()
    
    lazy var typeCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        
        // layout.itemSize = CGSize(width: 130, height: 40)
        //collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(typeNameLabel)
        contentView.addSubview(showAllButton)
        contentView.addSubview(typeCollectionView)
        
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.register(TypeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TypeCollectionViewCell.key)
        
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
        typeNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().inset(10)
        }
        
        showAllButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(10)
        }
        
        typeCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(typeNameLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        
    }
    
    //MARK: - Действие кнопки searchButton
    @objc private func showAllButtonPressed() {
        print("showAll")
    }
    
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionCell = typeCollectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.key,
                                                                       for: indexPath) as? TypeCollectionViewCell {
            
            
//            switch indexPath.row {
//            case FireBaseTypeEnum.architecture.rawValue:
//                collectionCell.nameModelLabel.text = ""
//            }
            
            collectionCell.layer.cornerRadius = 6
            collectionCell.dropShadow(width: 3,
                                      height: 3)
            
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 20,
                            bottom: 20,
                            right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = contentView.frame.size.width
        return CGSize(width: width * 0.8, height: width * 0.3)
        
    }
    
    
}
