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
            return NSLocalizedString("wrongPassword",
                                     comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("emailAlreadyInUse",
                                     comment: "")
        case .userNotFound:
            return NSLocalizedString("userNotFound",
                                     comment: "")
        case .userDisabled:
            return NSLocalizedString("userDisabled",
                                     comment: "")
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return NSLocalizedString("invalidEmail",
                                     comment: "")
        case .networkError:
            return NSLocalizedString("networkError",
                                     comment: "")
        case .weakPassword:
            return NSLocalizedString("weakPassword",
                                     comment: "")
        default:
            return NSLocalizedString("unknown",
                                     comment: "")
        }
    }
    
}
