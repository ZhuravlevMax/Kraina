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
    var models: [QueryDocumentSnapshot] = [] {
        didSet {
            typeCollectionView.reloadData()
        }
    }
    var forVC: ModelFromDelegate?
    
    //MARK: - Создание элементов UI
    private lazy var forWrapView: UIView = {
        let view = UIView()
        return view
    }()
    
     lazy var typeNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return nameLabel
    }()
    
    private lazy var showAllButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = .clear
        moveButton.setTitle("ВCE",
                            for: .normal)
        moveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor( AppColorsEnum.mainAppUIColor,
                                  for: .normal)
        moveButton.addTarget(self, action: #selector(self.showAllButtonPressed),
                             for: .touchUpInside)
        return moveButton
    }()
    
    lazy var typeCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(forWrapView)
        forWrapView.addSubview(typeNameLabel)
        forWrapView.addSubview(showAllButton)
        contentView.addSubview(typeCollectionView)
        
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.register(TypeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TypeCollectionViewCell.key)
        typeCollectionView.isPagingEnabled = true
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
        
        forWrapView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
        
        typeNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            //$0.top.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        showAllButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            //$0.top.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        typeCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(forWrapView.snp.bottom)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        
    }
    
    //MARK: - Действие кнопки searchButton
    @objc private func showAllButtonPressed() {
        forVC?.openFavoriteVC(models: models)
        print("showAll")
    }
    
}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionCell = typeCollectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.key,
                                                                       for: indexPath) as? TypeCollectionViewCell {
            collectionCell.configure(with: models[indexPath.row])
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 20,
                            bottom: 10,
                            right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = contentView.frame.size.width
        return CGSize(width: width * 0.88, height: width * 0.42)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        forVC?.openModelVC(model: models[indexPath.row])
        print("collection Item")
    }

}
