//
//  FireBaseManager.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import Firebase

class FireBaseManager {
    
    //MARK: - Объявление переменных
    static let shared = FireBaseManager(settings: FirestoreSettings())
    var db = Firestore.firestore()
    let settings: FirestoreSettings
    let ref = Database.database().reference()
    var userFavorites: [String]?
    
    
    init (settings: FirestoreSettings) {
        self.settings = settings
        Firestore.firestore().settings = settings
    }
    
    //MARK: - метод для получения всей коллекции
    func getMultipleAll(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {

        db.collection(collection).getDocuments() { (querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {return}
            let modelsArray = querySnapshot.documents
            completion(modelsArray)
        }
    }
    
    //MARK: - метод для получения полей одного документа
    func getPost(collection: String, docName:String, completion: @escaping (FireBaseDocument?) -> Void) {
        db.collection(collection).document(docName).getDocument { document, error in
            guard error == nil,
                  let adressUnwrapped = document?.get("\(FireBaseFieldsEnum.adress)") as? String,
                  let coordinateUnwrapped = document?.get("\(FireBaseFieldsEnum.coordinate)") as? [Double],
                  let descriptionUnwrapped = document?.get("\(FireBaseFieldsEnum.description)") as? String,
                  let nameUnwrapped = document?.get("\(FireBaseFieldsEnum.name)") as? String
            else { completion(nil); return}
            let doc = FireBaseDocument(adress: adressUnwrapped, coordinate: coordinateUnwrapped, description: descriptionUnwrapped, name: nameUnwrapped)
            completion(doc)
        }
    }
    
    //MARK: - метод для получения одной картинки из папки в БД
    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathReference = reference.child("\(FireBaseCastlesEnum.bihovskiyZamok)")
        var image: UIImage = UIImage(named: "defaultPic")!
        let fileReference = pathReference.child(picName + ".jpeg")
        fileReference.getData(maxSize: 4096) { data, error in
            guard let dataUnwrapped = data else {return}
            guard error == nil, let imageUnwrapped = UIImage(data: dataUnwrapped) else { completion(image); return}
            image = imageUnwrapped
            completion(image)
        }
    }
    
    //MARK: - метод для получения массива ссылок объекта
    func getImagesPathArray(model: QueryDocumentSnapshot) -> [String] {
        let modelData = model.data()
        
        let imagesDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.images)")
        }
        
        if let imagesDictUnwrapped = imagesDict, let imageUrls = imagesDictUnwrapped.value as? [String] {
            return imageUrls
        }
        return [""]
    }
    
    //MARK: - метод для получения массива с координатами
    
    func getCoordinatesArray(model: QueryDocumentSnapshot) -> [Double] {
        let modelData = model.data()
        
        let coordinatesDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.coordinate)")
        }
        
        if let coordinatesDictUnwrapped = coordinatesDict, let coordinates = coordinatesDictUnwrapped.value as? [Double] {
            return coordinates
        }
        return [0]
    }
    
    
    
    //MARK: - метод для получения названия достопримечательности по кооринатам
    func getNameByCoordinate(models: [QueryDocumentSnapshot], latitude: Double) -> String {
        for model in models {
            let coordinates = getCoordinatesArray(model: model)
            if coordinates.contains(latitude){
                let modelData = model.data()
                let nameDict = modelData.first { key, value in
                    return key.contains("\(FireBaseFieldsEnum.name)")
                }
                if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
                    return name
                }
            }
        }
        return ""
    }
    
    //MARK: - метод для получения достопримечательности по кооринатам
    func getModelByCoordinate(collection: String, latitude: Double, completion: @escaping (QueryDocumentSnapshot) -> Void) {
        db.collection(collection).getDocuments() { [weak self] (querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {return}
            var model: QueryDocumentSnapshot?
            querySnapshot.documents.forEach({
                guard let self = self else {return}
                let coordinates = self.getCoordinatesArray(model: $0)
                if coordinates.contains(latitude) {
                    model = $0
                }
            })
            guard let model = model else {return}
            completion(model)
        }
    }
    
    //MARK: - метод для получения названия достопримечательности
    func getModelName(model: QueryDocumentSnapshot) -> String {
        let modelData = model.data()
        let nameDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.name)")
        }
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
            return name
        }
        return ""
    }
    
    //MARK: - метод для получения адреса достопримечательности
    func getModelAdress(model: QueryDocumentSnapshot) -> String {
        let modelData = model.data()
        let adressDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.adress)")
        }
        if let adressDictUnwrapped = adressDict, let adress = adressDictUnwrapped.value as? String {
            return adress
        }
        return ""
    }
    
    //MARK: - метод для получения описания достопримечательности
    func getModelDescription(model: QueryDocumentSnapshot) -> String {
        let modelData = model.data()
        let descriptionDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.description)")
        }
        if let descriptionDictUnwrapped = descriptionDict, let description = descriptionDictUnwrapped.value as? String {
            return description
        }
        return ""
    }
    
    //MARK: - метод для получения типа достопримечательности
    func getModelType(model: QueryDocumentSnapshot) -> String {
        let modelData = model.data()
        let typeDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.type)")
        }
        if let typeDictUnwrapped = typeDict, let type = typeDictUnwrapped.value as? String {
            return type
        }
        return ""
    }
    
    //MARK: - метод для получения типа на русском достопримечательности
    func getModelRusType(model: QueryDocumentSnapshot) -> String {
        let modelData = model.data()
        let typeDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.rusType)")
        }
        if let typeDictUnwrapped = typeDict, let type = typeDictUnwrapped.value as? String {
            return type
        }
        return ""
    }
    
    //MARK: - метод для получения всех данных пользователя
    func getUserData(completion: @escaping (Any) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("\(UsersFieldsEnum.users)").child(userId).observe(.value) { snapshot in
            guard let value = snapshot.value, snapshot.exists() else {
                print("ERROR")
                return
            }
            completion(value)
        }
    }
    
    
    //MARK: - метод получения избранного юзера
    func getUserFavoritesArray(completion: @escaping ([String]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("\(UsersFieldsEnum.users)").child(userId).getData {error, snapshot in
            guard let snapshotUnwrapped = snapshot else {return}
            if let value = snapshotUnwrapped.value, snapshotUnwrapped.exists(), let valueDict = value as? [String : Any] {
                let favoritesDict = valueDict.first { key, value in
                    return key.contains("\(UsersFieldsEnum.favorites)")
                }
                guard let favoritesDictUnwrapped = favoritesDict, let favorites = favoritesDictUnwrapped.value as? [String] else {return}
                completion(favorites)
            }
        }
        
    }
}


