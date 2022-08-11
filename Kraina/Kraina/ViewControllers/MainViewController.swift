//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var documentArray: [FireBaseDocument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Главная"
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.green
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        
    }

    @IBAction func rainAction(_ sender: Any) {
        Kraina.FireBaseManager.shared.getPost(collection: FireBaseCollectionsEnum.castles.rawValue, docName: FireBaseCastlesEnum.bihovskiyZamok.rawValue) { doc in
            guard let docUnwrapped = doc else {return}

            self.documentArray.append(docUnwrapped)
            self.adressLabel.text = docUnwrapped.adress
            self.longtitudeLabel.text = docUnwrapped.longtitude
            self.latitudeLabel.text = docUnwrapped.latitude
            
            self.nameLabel.text = docUnwrapped.name

        }
        Kraina.FireBaseManager.shared.getImage(picName: "bihovskiyZamok2") { image in
            self.picture.image = image
        }
        
        FireBaseManager.shared.getMultipleAll(collection: FireBaseCollectionsEnum.castles.rawValue, completion: { models in
            guard let Id = models.first?.documentID else {return}
            print(models.count)
            self.descriptionLabel.text = Id
            
        })
    }
    
//    @IBAction func snowAction(_ sender: Any) {
//        FireBaseManager.shared.getPost(collection: "cars", docName: "middleCar") { doc in
//            guard doc != nil else {return}
//            self.label1.text = doc?.field1
//            self.label2.text = doc?.field2
//        }
//        FireBaseManager.shared.getImage(picName: "snow") { image in
//            self.picture.image = image
//        }
//    }
}

