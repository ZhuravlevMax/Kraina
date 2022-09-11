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
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        return view
    }()
    
    private lazy var titleRegisterLable: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = NSLocalizedString("RegistrationViewController.titleRegisterLable.text",
                                           comment: "")
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.returnKeyType = UIReturnKeyType.done
        textField.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("RegistrationViewController.emailTextField.placeholder",
                                      comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("RegistrationViewController.passwordTextField.placeholder",
                                      comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
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
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("RegistrationViewController.confirmPasswordTextField.placeholder",
                                      comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
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
        moveButton.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        moveButton.setTitle(NSLocalizedString("RegistrationViewController.registerButton.title",
                                              comment: ""),
                            for: .normal)
        moveButton.layer.cornerRadius = 10
        moveButton.setTitleColor(.white,
                                 for: .normal)
        moveButton.dropShadow()
        moveButton.addTarget(self,
                             action: #selector(self.registerButtonPressed),
                             for: .touchUpInside)
        return moveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
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
            if passwordText == confirmPasswordText {
                Auth.auth().createUser(withEmail: email,
                                       password: passwordText) {[weak self] result, error in
                    if error != nil {
                        guard let self = self,
                              let error = error else {return}
                        print(error._code)
                        self.handleError(error)
                        return
                    } else {
                        if let resultUnwrapped = result {
                            print(resultUnwrapped.user.uid)
                            let ref = Database.database().reference().child("\(UsersFieldsEnum.users)")
                            ref.child(resultUnwrapped.user.uid).updateChildValues(["\(UsersFieldsEnum.email)" : email,
                                                                                   "\(UsersFieldsEnum.favorites)" : [""]])
                            
                        }
                        UserDefaults.standard.set(true, forKey: "\(UserDefaultsKeysEnum.notFirstTime)")
                    }
                }
            } else {
                doErrorAlert(title: NSLocalizedString("Error",
                                                      comment: ""), message: NSLocalizedString("PasswordsDoNotMatch",
                                                                                               comment: ""))
            }
        }
    }
}
