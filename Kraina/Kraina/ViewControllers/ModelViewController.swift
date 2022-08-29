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
import Firebase

class ModelViewController: UIViewController {
    
    //MARK: - Создание переменных
    //Сюда передаю нужную модель/достопримечательность
    private var model: QueryDocumentSnapshot?
    private lazy var favoriteState = false
    var favouriteTypeVC: CheckFavouriteDelegate?
    var favouriteModels: [QueryDocumentSnapshot]?
    
    //MARK: - Создание элементов UI
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13,
                                       weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var coordinatesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12,
                                       weight: .ultraLight)
        return label
    }()
    
    private lazy var showDescriptionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColorsEnum.mainAppUIColor
        button.setTitle("Посмотреть на карте",
                        for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white,
                             for: .normal)
        button.addTarget(self,
                         action: #selector(showDescriptionButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var modelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14,
                                       weight: .light)
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
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private lazy var addToFavoriteButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = AppColorsEnum.mainAppUIColor
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 35,
                              height: 35)
        button.setImage(UIImage(systemName: "bookmark"),
                        for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white,
                             for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self,
                         action: #selector(addToFavoriteButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = AppColorsEnum.mainAppUIColor
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 35,
                              height: 35)
        button.setImage(UIImage(systemName: "chevron.backward"),
                        for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setTitleColor(.white,
                             for: .normal)
        button.addTarget(self,
                         action: #selector(backButtonPressed),
                         for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
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
        
        FireBaseManager.shared.getUserFavoritesArray {
            self.favoriteState = $0.contains(model.documentID)
            self.favoriteState ? self.addToFavoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal) : self.addToFavoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addToFavoriteButton)
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        backToRoot()
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
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        coordinatesLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(adressLabel.snp.bottom).offset(10)
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
    
    //MARK: - метод для кнопки добавить в избранное в нав баре
    @objc private func addToFavoriteButtonPressed() {
        FireBaseManager.shared.getUserFavoritesArray { [self] favorites in
            print(favorites)
            var favoritesArray = favorites
            guard let model = model,
                  let userId = Auth.auth().currentUser?.uid
            else {return}
            
            if favoritesArray.contains(model.documentID) {
                addToFavoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                if favoritesArray.contains("\(model.documentID)"){favoritesArray.removeAll(where:{ "\(model.documentID)" == $0 })}
                let ref = Database.database().reference().child("\(UsersFieldsEnum.users)")
                ref.child(userId).updateChildValues(["\(UsersFieldsEnum.favorites)" : favoritesArray])
            } else {
                addToFavoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                favoritesArray.append("\(model.documentID)")
                let ref = Database.database().reference().child("\(UsersFieldsEnum.users)")
                ref.child(userId).updateChildValues(["\(UsersFieldsEnum.favorites)" : favoritesArray])
            }
            
            guard var favouriteModelsUnwrapped = favouriteModels,
                  let favouriteTypeVCUnwrapped = favouriteTypeVC else {return}
            favouriteModelsUnwrapped = favouriteModelsUnwrapped.filter {
                FireBaseManager.shared.getModelName(model: $0) != FireBaseManager.shared.getModelName(model: model)
            }
            
            favouriteTypeVCUnwrapped.setFavouriteArray(modelsArray: favouriteModelsUnwrapped)
        }
        //вибрация по нажатию на иконку
        let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
    }
    
    //MARK: - метод для кнопки назад в нав баре
    @objc private func backButtonPressed() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
    }
}

extension ModelViewController {
    func backToRoot() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(back))
        swipeDownGesture.direction = .right
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func back() {
        guard let navigationControllerUnwrapped = navigationController else {return}
        navigationControllerUnwrapped.popViewController(animated: true)
    }
}
