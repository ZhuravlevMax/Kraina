//
//  ModelMainTableViewCell.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.08.22.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class ModelMainTableViewCell: UITableViewCell {
    
    static let identifier = "ModelMainTableViewCell"
    var mainImageView = UIImageView()
    
    
    var model: QueryDocumentSnapshot?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainImageView)
        
        configureImageView()
        
        DispatchQueue.main.async {
            self.setImageViewConstraite()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureImageView() {
        mainImageView.clipsToBounds = true
    }
    
    func setImageViewConstraite() {
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(300)
            }
                
    }
    
    func setImage(model: QueryDocumentSnapshot) {
        let imagesUrlArray = FireBaseManager.shared.getImagesPathArray(model: model)
        guard let imageURL = imagesUrlArray.first else {return}
        self.mainImageView.load(url: imageURL)
       
    }
    
}
