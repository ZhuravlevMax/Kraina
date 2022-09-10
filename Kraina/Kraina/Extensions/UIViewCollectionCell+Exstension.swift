//
//  UIViewCollectionCell+Exstension.swift
//  Kraina
//
//  Created by Максим Журавлев on 10.09.22.
//

import Foundation

import Foundation
import UIKit
import FirebaseAuth
import Firebase

func showLocalizedModelName(for model: QueryDocumentSnapshot) -> String {
    return Locale.current.languageCode == "\(LanguageEnum.ru)" ? FireBaseManager.shared.getModelName(model: model) : FireBaseManager.shared.getModelNameEn(model: model)
}
