//
//  AuthErrorCode+Extension.swift
//  Kraina
//
//  Created by Максим Журавлев on 5.09.22.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode.Code {
    var errorMessage: String {
        switch self {
        case .wrongPassword:
            return "Your password is incorrect."
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        default:
            return "Unknown error occurred"
        }
    }
    
}
