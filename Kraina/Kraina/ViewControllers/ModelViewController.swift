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
   private var mainImageView = UIImageView()
   private var nameLabel = UILabel()
   private var adressLabel = UILabel()
   private var coordinatesLabel = UILabel()
   private var showOnMapButton = UIButton(type: .system)
   private var modelDescription = UILabel()
    
    private lazy var modelScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = view.frame
        scrollView.contentSize = contentSize
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

    //Сюда передаю нужную модель/достопримечательность
    private var model: QueryDocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        //убираю safe area
        modelScrollView.insetsLayoutMarginsFromSafeArea = false
        modelScrollView.contentInsetAdjustmentBehavior = .never
        
        view.layoutSubviews()

        guard let model = model else {return}

        //MARK: - добавление элементов UI на View
        view.addSubview(modelScrollView)
        modelScrollView.addSubview(contentView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(coordinatesLabel)
        contentView.addSubview(showOnMapButton)
        contentView.addSubview(modelDescription)
        
        setImage(model: model)

        setImageViewConstraite()

        initialize()
        
    }

    private func initialize() {

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: - Работа с внешним видом элементов
   private func setImageViewConstraite() {
        
        showOnMapButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        showOnMapButton.setTitle("Посмотреть на карте", for: .normal)
        showOnMapButton.layer.cornerRadius = 10
        showOnMapButton.setTitleColor(.white, for: .normal)
        showOnMapButton.addTarget(self, action: #selector(showOnMapButtonPressed), for: .touchUpInside)

        DispatchQueue.main.async {
            guard let model = self.model else {return}
            self.nameLabel.text = FireBaseManager.shared.getModelName(model: model)
            self.nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            
            self.adressLabel.text = FireBaseManager.shared.getModelAdress(model: model)
            self.adressLabel.font = UIFont.systemFont(ofSize: 11, weight: .ultraLight)
            self.adressLabel.numberOfLines = 0
            
            self.coordinatesLabel.text = "\(FireBaseManager.shared.getCoordinatesArray(model: model)[FirebaseCoordinateEnum.latitude.rawValue]), \(FireBaseManager.shared.getCoordinatesArray(model: model)[FirebaseCoordinateEnum.longtitude.rawValue])"
            self.adressLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
            
            self.modelDescription.numberOfLines = 0
            self.modelDescription.text = "\(FireBaseManager.shared.getModelDescription(model: model))"
            self.modelDescription.textAlignment = .left
            self.modelDescription.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
        
        //MARK: - контсрейты для элементов
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
        
        showOnMapButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(coordinatesLabel).inset(30)
            $0.height.equalTo(50)
        }

        modelDescription.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(showOnMapButton).inset(80)
            $0.bottom.equalToSuperview().offset(-80)
        }
                
    }
    
   private func setImage(model: QueryDocumentSnapshot) {
        let imagesUrlArray = FireBaseManager.shared.getImagesPathArray(model: model)
        guard let imageURL = imagesUrlArray.first else {return}
            self.mainImageView.load(url: imageURL)
        mainImageView.contentMode = .scaleAspectFill
    }
    
    @objc private func showOnMapButtonPressed() {
        
        let forModelMapVC  = ForModelMapViewController()
        guard let model = model else {return}
        
        forModelMapVC.model = model
        forModelMapVC.coordinate = FireBaseManager.shared.getCoordinatesArray(model: model)
        self.navigationController?.pushViewController(forModelMapVC, animated: true)
        print("LOL")
    }
    
    //MARK: - Метод для получения модели из других VC
    func setModel(modelToSet: QueryDocumentSnapshot) {
        model = modelToSet
    }
    
}
