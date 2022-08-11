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

    
    //MARK: - функция для получения всей коллекции
     func getMultipleAll(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
            // [START get_multiple_all]
            db.collection(collection).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var modelsArray: [QueryDocumentSnapshot] = []
                    guard let querySnapshot = querySnapshot else {return}
                    for document in querySnapshot.documents {
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
        db.collection(collection).document(docName).getDocument { document, error in
            guard error == nil,
                  let adressUnwrapped = document?.get("\(FireBaseFieldsEnum.adress)") as? String,
                  let longtitudeUnwrapped = document?.get("\(FireBaseFieldsEnum.longtitude)") as? String,
                  let latitudeUnwrapped = document?.get("\(FireBaseFieldsEnum.latitude)") as? String,
                  let descriptionUnwrapped = document?.get("\(FireBaseFieldsEnum.description)") as? String,
                  let nameUnwrapped = document?.get("\(FireBaseFieldsEnum.name)") as? String
                  else { completion(nil); return}
            
            let doc = FireBaseDocument(adress: adressUnwrapped, longtitude: longtitudeUnwrapped, latitude: latitudeUnwrapped, description: descriptionUnwrapped, name: nameUnwrapped)
            completion(doc)
        }
    }
    
    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathReference = reference.child("\(FireBaseCastlesEnum.bihovskiyZamok)")
        
        
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


