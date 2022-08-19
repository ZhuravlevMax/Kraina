//
//  LogInViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 19.08.22.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    //MARK: - Создание переменных
    var register = false
    
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
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите Email"
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
        let button = UIButton()
        button.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self, action: #selector(self.logInButtonPressed), for: .touchUpInside)
        button.dropShadow()
        return button
    }()
    
    private lazy var createAccLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = "Нет аккаунта?"
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return nameLabel
    }()
    
    private lazy var сreateAccButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.addTarget(self, action: #selector(self.сreateAccButtonPressed), for: .touchUpInside)
        button.dropShadow()
        return button
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        view.backgroundColor = .white
        
        //MARK: - Добавление элементов на экран
        view.addSubview(mainView)
        mainView.addSubview(logInView)
        logInView.addSubview(titleLoginLable)
        logInView.addSubview(emailTextField)
        logInView.addSubview(passwordTextField)
        logInView.addSubview(logInButton)
        logInView.addSubview(createAccLabel)
        logInView.addSubview(сreateAccButton)
        
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
        
        emailTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(titleLoginLable).inset(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(emailTextField).inset(50)
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

