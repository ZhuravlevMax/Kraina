//
//  MapViewDelegate.swift
//  Kraina
//
//  Created by Максим Журавлев on 3.09.22.
//

import Foundation
import Firebase

protocol MapViewDelegate {
    func showModel(model: QueryDocumentSnapshot)
}
