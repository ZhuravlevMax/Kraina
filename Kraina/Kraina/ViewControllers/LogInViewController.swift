//
//  LogInViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 19.08.22.
//

import UIKit
import Firebase
import SnapKit
import GoogleSignIn

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Создание переменных
    var register = false
    
    //MARK: - Создание элементов UI
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        return view
    }()
    
    private lazy var logInView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        view.dropShadow()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var titleLoginLable: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = NSLocalizedString("LoginViewController.titleLoginLable.text",
                                           comment: "")
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return nameLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("RegistrationViewController.emailTextField.placeholder",
                                      comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
        textField.keyboardType = UIKeyboardType.emailAddress
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
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("RegistrationViewController.passwordTextField.placeholder",
                                      comment: ""),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.tabbarColor)")
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.isSecureTextEntry = true
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        button.setTitle(NSLocalizedString("LoginViewController.logInButton.title",
                                          comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.logInButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var createAccLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.text = NSLocalizedString("LoginViewController.createAccLabel.text",
                                           comment: "")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return nameLabel
    }()
    
    private lazy var сreateAccButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.mainAppUIColor)")
        button.setTitle(NSLocalizedString("RegistrationViewController.registerButton.title",
                                          comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.addTarget(self,
                         action: #selector(self.сreateAccButtonPressed),
                         for: .touchUpInside)
        button.dropShadow()
        return button
    }()
    
    private lazy var сreateAccGoogleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.addTarget(self,
                         action: #selector(self.сreateAccGoogleButtonPressed),
                         for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.dropShadow()
        return button
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        view.layoutSubviews()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        //MARK: - Добавление элементов на экран
        view.addSubview(mainView)
        mainView.addSubview(logInView)
        logInView.addSubview(titleLoginLable)
        logInView.addSubview(emailTextField)
        logInView.addSubview(passwordTextField)
        logInView.addSubview(logInButton)
        logInView.addSubview(createAccLabel)
        logInView.addSubview(сreateAccButton)
        logInView.addSubview(сreateAccGoogleButton)
        
        updateViewConstraints()
        
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        mainView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview()
        }
        
        logInView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(400)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
        
        titleLoginLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        emailTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(titleLoginLable.snp.bottom).offset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
        }
        
        logInButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        сreateAccGoogleButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(logInButton.snp.bottom).offset(10)
        }
        
        createAccLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(сreateAccGoogleButton.snp.bottom).offset(20)
        }
        
        сreateAccButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(createAccLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        
        
       // hideKeyboardWhenTappedAround()
        super.updateViewConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 110
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - Действие кнопки logIn
    @objc private func logInButtonPressed() {
        
        if let email = emailTextField.text,
           let passwordText = passwordTextField.text,
           emailTextField.text != "",
           passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: email,
                               password: passwordText) {[weak self] result, error in
                if error != nil {
                    guard let self = self,
                          let error = error else {return}
                    print(error._code)
                    self.handleError(error)
                    return
                } else {
                    UserDefaults.standard.set(true, forKey: "\(UserDefaultsKeysEnum.notFirstTime)")
                }
            }
            
        } else {
            doErrorAlert(title: NSLocalizedString("Error",
                                                  comment: ""), message: NSLocalizedString("emptyFields",
                                                                                           comment: ""))
        }
    }
    
    //MARK: - Действие кнопки SignIn Google
    @objc private func сreateAccGoogleButtonPressed() {
        
        //MARK: - Регистрация через гугл
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
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
                        Database.database().reference().child("\(UsersFieldsEnum.users)").child(resultUnwrapped.user.uid).observe(.value) { snapshot in
                            if let value = snapshot.value, snapshot.exists() {
                                ref.child(resultUnwrapped.user.uid).updateChildValues(["\(UsersFieldsEnum.email)" : user?.userID])
                            } else {
                                ref.child(resultUnwrapped.user.uid).updateChildValues(["\(UsersFieldsEnum.email)" : user?.userID,
                                                                                       "\(UsersFieldsEnum.favorites)" : [""]])
                            }
                        }
                    }
                    UserDefaults.standard.set(true, forKey: "\(UserDefaultsKeysEnum.notFirstTime)")
                }
            }
        }
        
    }
    
    //MARK: - Действие кнопки createAcc
    @objc private func сreateAccButtonPressed() {
        let registerVC  = RegistrationViewController()
        
        self.present(registerVC, animated: true)
    }
    
}

