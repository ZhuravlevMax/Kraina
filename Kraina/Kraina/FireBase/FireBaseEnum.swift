//
//  FireBaseEnum.swift
//  Kraina
//
//  Created by Максим Журавлев on 11.08.22.
//

import Foundation

enum FireBaseCollectionsEnum {
    case attraction
}

enum FireBaseTypeEnum {
    case architecture
    case religion
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
    case images
    case type
}

enum FirebaseCoordinateEnum: Int {
    case latitude = 0
    case longtitude
}

enum UsersFieldsEnum {
    case users
    case email
    case favorites
}
