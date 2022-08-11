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
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
     func getMultipleAll(collection: String) {
            // [START get_multiple_all]
        let db = configureFB()
            db.collection(collection).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var modelsArray: [QueryDocumentSnapshot] = []
                    var dataDictionary:[String : Any] = [:]
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        modelsArray.append(document)
                        print(modelsArray)
                        guard let firstModel = modelsArray.first?.data() else {return}
                        dataDictionary = firstModel
                        print(dataDictionary["name"])
                    }
                }
            }
            // [END get_multiple_all]
        }
    
    func getPost(collection: String, docName:String, completion: @escaping (FireBaseDocument?) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument { document, error in
            guard error == nil else { completion(nil); return}
            
            let doc = FireBaseDocument(adress: document?.get() as! String, longtitude: document?.get("longtitude") as! String, latitude: document?.get("latitude") as! String, description: document?.get("description") as! String, name: document?.get("name") as! String)
            completion(doc)
        }
    }
    
    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathReference = reference.child("bihovskiyZamok")
        
        
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


