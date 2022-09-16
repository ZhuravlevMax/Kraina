//
//  modelFromCollectionDelegate.swift
//  Kraina
//
//  Created by Максим Журавлев on 31.08.22.
//

import Foundation
import Firebase

protocol ModelFromDelegate: AnyObject {
    func openModelVC(model: QueryDocumentSnapshot)
    func openOneTypeItemsViewController(models: [QueryDocumentSnapshot])
}

