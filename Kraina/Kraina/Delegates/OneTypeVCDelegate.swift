//
//  OneTypeVCDelegate.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.09.22.
//

import Foundation
import Firebase

protocol OneTypeVCDelegate: AnyObject {
    func reloadOneTypeTableView()
    func addToFavouriteFromCell(model: QueryDocumentSnapshot)
}

