//
//  RegistrationViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 18.08.22.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    //MARK: - Создание переменных
    var successfullLabel: (() -> Void)?
    
    //MARK: - Создание элементов UI
    private lazy var registerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleRegisterLable: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = "Регистрация"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите email"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.keyboardType = .emailAddress
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите пароль"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Подтвердите пароль"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = AppColorsEnum.mainAppUIColor
        moveButton.setTitle("Подтвердить", for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.addTarget(self, action: #selector(self.registerButtonPressed), for: .touchUpInside)
        return moveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //MARK: - Добавление элементов на экран
        view.addSubview(registerView)
        registerView.addSubview(titleRegisterLable)
        registerView.addSubview(emailTextField)
        registerView.addSubview(passwordTextField)
        registerView.addSubview(confirmPasswordTextField)
        registerView.addSubview(registerButton)
        
        updateViewConstraints()
        
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        registerView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        titleRegisterLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(50)
        }
        
        emailTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(titleRegisterLable).inset(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(emailTextField).inset(50)
        }
        
        confirmPasswordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(passwordTextField).inset(50)
        }
        
        registerButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(confirmPasswordTextField).inset(50)
            $0.height.equalTo(50)
        }
        
        
        super.updateViewConstraints()
    }
    
    //MARK: - Действие кнопки createAcc
    @objc private func registerButtonPressed() {
        if let email = emailTextField.text,
           let passwordText = passwordTextField.text,
           let confirmPasswordText = confirmPasswordTextField.text {
            if isValidEmail(testStr: email), passwordText.count > 5, passwordText == confirmPasswordText {
                Auth.auth().createUser(withEmail: email, password: passwordText) {[self] result, error in
                    print(error)
                    if let resultUnwrapped = result {
                        print(resultUnwrapped.user.uid)
                        let ref = Database.database().reference().child("\(UsersFieldsEnum.users)")
                        ref.child(resultUnwrapped.user.uid).updateChildValues(["\(UsersFieldsEnum.email)" : email, "\(UsersFieldsEnum.favorites)" : [""]])
                        
                    } else {
                        doErrorAlert(title: "Ошибка", message: "Возможно данный email уже зарегистрирован")
                    }
                }
            } else {
                doErrorAlert(title: "Ошибка", message: "Пожалуйста проверьте введенные данные")
            }
            print("register")
        }
    }
}
