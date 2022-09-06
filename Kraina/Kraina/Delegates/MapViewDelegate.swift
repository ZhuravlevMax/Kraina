//
//  MapViewDelegate.swift
//  Kraina
//
//  Created by Максим Журавлев on 3.09.22.
//

import Foundation
import Firebase

protocol MapViewDelegate: AnyObject {
    func showModel(model: QueryDocumentSnapshot)
    func moveTo(latData: Double,lonData: Double )
    func doClustersFromSearch(models: [QueryDocumentSnapshot])
}
