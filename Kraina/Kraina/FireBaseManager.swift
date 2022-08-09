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
    
    func getPost(collection: String, docName:String, completion: @escaping (FireBaseDocument?) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument { document, error in
            guard error == nil else { completion(nil); return}
            
            let doc = FireBaseDocument(field1: document?.get("field1") as! String, field2: document?.get("field2") as! String)
            completion(doc)
        }
    }
    
    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        let reference = storage.reference()
        let pathReference = reference.child("pictures")
        
        var image: UIImage = UIImage(named: "defaultPic")!
        
        let fileReference = pathReference.child(picName + ".jpeg")
        fileReference.getData(maxSize: 2024*2024) { data, error in
            guard error == nil else { completion(image); return}
            
            image = UIImage(data: data!)!
            
            completion(image)
        }
    }
}


