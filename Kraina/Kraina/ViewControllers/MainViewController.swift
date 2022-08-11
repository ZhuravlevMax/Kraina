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
        Kraina.FireBaseManager.shared.getPost(collection: "castles", docName: "bihovskiyZamok") { doc in
            guard doc != nil else {return}

            self.documentArray.append(doc!)
            self.adressLabel.text = doc?.adress
            self.longtitudeLabel.text = doc?.longtitude
            self.latitudeLabel.text = doc?.latitude
            self.descriptionLabel.text = doc?.description
            self.nameLabel.text = doc?.name

        }
        Kraina.FireBaseManager.shared.getImage(picName: "bihovskiyZamok2") { image in
            self.picture.image = image
        }
        
        FireBaseManager.shared.getMultipleAll(collection: "castles") 
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

