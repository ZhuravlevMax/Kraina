//
//  ModelViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.08.22.
//
import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class ModelViewController: UIViewController {
    
    //MARK: - Создание переменных
    //Сюда передаю нужную модель/достопримечательность
    private var model: QueryDocumentSnapshot?
    
    //MARK: - Создание элементов UI
    private var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var adressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .ultraLight)
        label.numberOfLines = 0
        return label
    }()
    
    private var coordinatesLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var showDescriptionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        button.setTitle("Посмотреть на карте", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showDescriptionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var modelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var modelScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = view.frame
        scrollView.contentSize = contentSize
        //убираю safe area
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layoutSubviews()
        
        guard let model = model else {return}
        
        //MARK: - добавление элементов UI на View
        view.addSubview(modelScrollView)
        modelScrollView.addSubview(contentView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(coordinatesLabel)
        contentView.addSubview(showDescriptionButton)
        contentView.addSubview(modelDescription)
        
        self.nameLabel.text = FireBaseManager.shared.getModelName(model: model)
        self.adressLabel.text = FireBaseManager.shared.getModelAdress(model: model)
        self.coordinatesLabel.text = "\(FireBaseManager.shared.getCoordinatesArray(model: model)[FirebaseCoordinateEnum.latitude.rawValue]), \(FireBaseManager.shared.getCoordinatesArray(model: model)[FirebaseCoordinateEnum.longtitude.rawValue])"
        self.modelDescription.text = "\(FireBaseManager.shared.getModelDescription(model: model))"
        
        setImage(model: model)
        initialize()
        updateViewConstraints()
    }
    
    private func initialize() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        modelScrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(view)
            $0.height.equalTo(300)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(340)
        }
        
        adressLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel).inset(30)
        }
        
        coordinatesLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressLabel).inset(30)
        }
        
        showDescriptionButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(coordinatesLabel).inset(30)
            $0.height.equalTo(50)
        }
        
        modelDescription.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(showDescriptionButton).inset(80)
            $0.bottom.equalToSuperview().offset(-80)
        }
        super.updateViewConstraints()
    }
    
    private func setImage(model: QueryDocumentSnapshot) {
        guard let imageURL = FireBaseManager.shared.getImagesPathArray(model: model).first else {return}
        self.mainImageView.load(url: imageURL)
    }
    
    //MARK: - Действие при нажатии кнопки showOnMapButton
    @objc private func showDescriptionButtonPressed() {
        
        let forModelMapVC  = ForModelMapViewController()
        guard let model = model else {return}
        
        forModelMapVC.setModel(modelToSet: model)
        //forModelMapVC.coordinate = FireBaseManager.shared.getCoordinatesArray(model: model)
        self.navigationController?.pushViewController(forModelMapVC, animated: true)
        print("LOL")
    }
    
    //MARK: - Метод для получения модели из других VC
    func setModel(modelToSet: QueryDocumentSnapshot) {
        model = modelToSet
    }
    
}
