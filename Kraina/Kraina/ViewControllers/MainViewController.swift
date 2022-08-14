//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit

class MainViewController: UIViewController {
    
    var documentArray: [FireBaseDocument] = []
    var coordinatesArray: [Double] = []
    
    lazy var snapBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Try out SnapKit!", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Главная"
        self.view.addSubview(snapBtn)
        
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.green
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    override func updateViewConstraints() {
        
        snapBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-120)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        super.updateViewConstraints()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.attraction)") { models in
            guard let model = models.first else {return}
            self.coordinatesArray = FireBaseManager.shared.getCoordinatesArray(model: model)
            print(self.coordinatesArray[FirebaseCoordinateEnum.latitude.rawValue])
            }
            
        }
    }

