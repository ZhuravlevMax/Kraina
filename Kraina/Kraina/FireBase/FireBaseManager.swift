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
    
    static let shared = FireBaseManager()
    var db = Firestore.firestore()
    let settings = FirestoreSettings()
    
    private func configureFB() -> Firestore {
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    //MARK: - функция для получения всей коллекции
     func getMultipleAll(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
            // [START get_multiple_all]
        let db = configureFB()
            db.collection(collection).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var modelsArray: [QueryDocumentSnapshot] = []
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        modelsArray.append(document)     
                    }
                    completion(modelsArray)
                }
            }
            // [END get_multiple_all]
        }
    
    //MARK: - функция для получения полей одного документа
    func getPost(collection: String, docName:String, completion: @escaping (FireBaseDocument?) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument { document, error in
            guard error == nil,
                  let adressUnwrapped = document?.get(FireBaseFieldsEnum.adress.rawValue) as? String,
                  let longtitudeUnwrapped = document?.get(FireBaseFieldsEnum.longtitude.rawValue) as? String,
                  let latitudeUnwrapped = document?.get(FireBaseFieldsEnum.latitude.rawValue) as? String,
                  let descriptionUnwrapped = document?.get(FireBaseFieldsEnum.description.rawValue) as? String,
                  let nameUnwrapped = document?.get(FireBaseFieldsEnum.name.rawValue) as? String
                  else { completion(nil); return}
            
            let doc = FireBaseDocument(adress: adressUnwrapped, longtitude: longtitudeUnwrapped, latitude: latitudeUnwrapped, description: descriptionUnwrapped, name: nameUnwrapped)
            completion(doc)
        }
    }
    
    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathReference = reference.child(FireBaseCastlesEnum.bihovskiyZamok.rawValue)
        
        
        var image: UIImage = UIImage(named: "defaultPic")!
        
        let fileReference = pathReference.child(picName + ".jpeg")
        fileReference.getData(maxSize: 2024*2024) { data, error in
            guard let dataUnwrapped = data else {return}
            guard error == nil, let imageUnwrapped = UIImage(data: dataUnwrapped) else { completion(image); return}

            image = imageUnwrapped
            
            completion(image)
        }
    }
}


