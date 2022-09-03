//
//  chooseTypeDelegate.swift
//  Kraina
//
//  Created by Максим Журавлев on 23.08.22.
//

import Foundation
import Firebase

protocol ChangeTypeDelegate: AnyObject {
    func changeMarkerType(modelsSet: [QueryDocumentSnapshot])
}
