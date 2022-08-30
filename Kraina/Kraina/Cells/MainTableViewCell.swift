//
//  MainTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 30.08.22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - Создание переменных
    static let key = "MainTableViewCell"
    
    //MARK: - Создание элементов UI
    private lazy var typeNameLabel: UILabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(typeNameLabel)
        contentView.addSubview(showAllButton)
        
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
        
        

    }
    
    //MARK: - Действие кнопки searchButton
    @objc private func showAllButtonPressed() {
        print("showAll")
    }

}
