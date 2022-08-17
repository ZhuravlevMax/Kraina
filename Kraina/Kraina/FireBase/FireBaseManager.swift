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

class FireBaseManager {
    
    static let shared = FireBaseManager(settings: FirestoreSettings())
    var db = Firestore.firestore()
    let settings: FirestoreSettings
    
    init (settings: FirestoreSettings) {
        self.settings = settings
        Firestore.firestore().settings = settings
    }
    //MARK: - метод для получения всей коллекции
    func getMultipleAll(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
        // [START get_multiple_all]
        db.collection(collection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var modelsArray: [QueryDocumentSnapshot] = []
                guard let querySnapshot = querySnapshot else {return}
                for document in querySnapshot.documents {
                    //print("\(document.documentID) => \(document.data())")
                    modelsArray.append(document)
                }
                completion(modelsArray)
            }
        }
        // [END get_multiple_all]
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
        db.collection(collection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var model: QueryDocumentSnapshot?
                guard let querySnapshot = querySnapshot else {return}
                
                for document in querySnapshot.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let coordinates = self.getCoordinatesArray(model: document)
                    if coordinates.contains(latitude) {
                        model = document
                    }
                }
                guard let model = model else {return}
                completion(model)
            }
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
    
}


