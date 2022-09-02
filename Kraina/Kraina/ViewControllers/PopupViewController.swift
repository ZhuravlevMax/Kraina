//
//  PopupViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 1.09.22.
//

import UIKit
import Firebase
import SPStorkController

class PopupViewController: UIViewController {
    
    //MARK: - Создание переменных
    private var model: QueryDocumentSnapshot?
    var forModelMapVC: ModelMapDelegate?
    
    //MARK: - Cоздание элементов UI
    
    private lazy var nameModelLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var adressModelLabel: UILabel = {
        let adressLabel = UILabel()
        adressLabel.numberOfLines = 0
        adressLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return adressLabel
    }()
    
    private lazy var moveToButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = AppColorsEnum.mainAppUIColor
        moveButton.setTitle("Построить маршрут", for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.addTarget(self, action: #selector(self.moveToButtonPressed), for: .touchUpInside)
        return moveButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - Добавление элементов на экран
        //view.addSubview(forShadowView)
        view.addSubview(nameModelLabel)
        view.addSubview(adressModelLabel)
        view.addSubview(moveToButton)
        
        view.backgroundColor = .white
        
        guard let model = model else {return}

        updateData(model: model)
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
    nameModelLabel.snp.makeConstraints {
        $0.left.equalToSuperview().inset(20)
        $0.right.equalToSuperview().inset(20)
        $0.top.equalToSuperview().inset(30)
    }
    
    adressModelLabel.snp.makeConstraints {
        $0.left.equalToSuperview().inset(20)
        $0.right.equalToSuperview().inset(20)
        $0.top.equalTo(nameModelLabel).inset(50)
    }
    
    moveToButton.snp.makeConstraints {
        $0.left.right.equalToSuperview().inset(20)
        $0.top.equalTo(adressModelLabel).inset(50)
        $0.height.equalTo(50)
    }
        super.updateViewConstraints()
    }
    
    //MARK: - Действие кнопки moveToButton
    @objc private func moveToButtonPressed() {
        forModelMapVC?.doNavigationAlert()
        print("LOL")
    }
    
    //MARK: - Метод для получения модели из других VC
    func setModel(setModel: QueryDocumentSnapshot) {
        model = setModel
    }
    
    func updateData(model: QueryDocumentSnapshot) {
        //MARK: - Текст для лейблов
        self.nameModelLabel.text = FireBaseManager.shared.getModelName(model: model)
        self.adressModelLabel.text = FireBaseManager.shared.getModelAdress(model: model)
    }

}
