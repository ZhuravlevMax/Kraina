//
//  FavoriteTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 26.08.22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    //MARK: - Создание переменных
    static let key = "favoriteTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

        updateViewConstraints()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Работа с констрейнтами
    func updateViewConstraints() {
    }
}
