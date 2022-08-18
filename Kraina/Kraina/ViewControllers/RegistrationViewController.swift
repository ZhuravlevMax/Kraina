//
//  RegistrationViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 18.08.22.
//

import UIKit

class RegistrationViewController: UIViewController {
    
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
         textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
         return textField
     }()
    
    private lazy var registerButton: UIButton = {
        let moveButton = UIButton()
        moveButton.backgroundColor = UIColor(red: 43/255, green: 183/255, blue: 143/255, alpha: 1)
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
        registerView.addSubview(nameTextField)
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
        
        nameTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(titleRegisterLable).inset(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(nameTextField).inset(50)
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
        print("register")
    }
    

}
