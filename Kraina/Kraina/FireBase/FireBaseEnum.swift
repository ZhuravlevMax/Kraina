//
//  FireBaseEnum.swift
//  Kraina
//
//  Created by Максим Журавлев on 11.08.22.
//

import Foundation

enum FireBaseCollectionsEnum {
    case castles
}

enum FireBaseCastlesEnum {
    case bihovskiyZamok
    case mirskiyZamok
}

enum FireBaseFieldsEnum {
    case adress
    case name
    case coordinate
    case description
}

enum FirebaseCoordinateEnum: Int {
    case longtitude = 0
    case latitude
}
