//
//  CheckFavouriteDelegate.swift
//  Kraina
//
//  Created by Максим Журавлев on 29.08.22.
//

import Foundation
import Firebase

protocol CheckFavouriteDelegate: AnyObject {
    func setFavouriteArray(modelsArray: [QueryDocumentSnapshot])
}
