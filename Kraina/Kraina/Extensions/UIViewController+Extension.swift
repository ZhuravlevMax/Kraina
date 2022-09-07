//
//  UIViewController+Extension.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import Foundation
import UIKit
import FirebaseAuth

extension UIViewController {
    func setupClearNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(hideKeyboard))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    //    //MARK: - Проверка введенного email
    //    func isValidEmail(testStr:String) -> Bool {
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    //        return emailTest.evaluate(with: testStr)
    //    }
    //
    //MARK: - AlertController для ошибок
    func doErrorAlert(title: String, message: String) {
        let errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "Ok", style: .default)
        errorAlertController.addAction(okButtonAction)
        self.present(errorAlertController, animated: true)
    }
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
