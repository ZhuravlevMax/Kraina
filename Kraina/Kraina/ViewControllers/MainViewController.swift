//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Создание переменных
    var documentArray: [FireBaseDocument] = []
    var coordinatesArray: [Double] = []
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logInView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.dropShadow()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var titleLoginLable: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = "Войдите в аккаунт"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите Логин"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите Пароль"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var logInButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        moveButton.setTitle("Войти", for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.dropShadow()
        moveButton.addTarget(self, action: #selector(self.logInButtonPressed), for: .touchUpInside)
        moveButton.dropShadow()
        return moveButton
    }()
    
    private lazy var createAccLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = "Нет аккаунта?"
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return nameLabel
    }()
    
    private lazy var сreateAccButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        moveButton.setTitle("Зарегистрироваться", for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.addTarget(self, action: #selector(self.сreateAccButtonPressed), for: .touchUpInside)
        moveButton.dropShadow()
        return moveButton
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
        
        title = "Главная"
        view.backgroundColor = .white
        
        //MARK: - Добавление элементов на экран
        view.addSubview(mainView)
        mainView.addSubview(logInView)
        logInView.addSubview(titleLoginLable)
        logInView.addSubview(nameTextField)
        logInView.addSubview(passwordTextField)
        logInView.addSubview(logInButton)
        logInView.addSubview(createAccLabel)
        logInView.addSubview(сreateAccButton)
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.gray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        updateViewConstraints()
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        logInView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(450)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
        
        titleLoginLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(50)
        }
        
        nameTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(titleLoginLable).inset(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(nameTextField).inset(50)
        }
        
        logInButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(passwordTextField).inset(50)
            $0.height.equalTo(50)
        }
        
        createAccLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(logInButton).inset(80)
        }
        
        сreateAccButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(createAccLabel).inset(30)
            $0.height.equalTo(50)
        }
        
        hideKeyboardWhenTappedAround()
        super.updateViewConstraints()
    }
    //MARK: - Действие кнопки logIn
    @objc private func logInButtonPressed() {
        print("login")
    }
    
    //MARK: - Действие кнопки createAcc
    @objc private func сreateAccButtonPressed() {
        let registerVC  = RegistrationViewController()
        self.present(registerVC, animated: true)
        print("create")
    }
    
}

