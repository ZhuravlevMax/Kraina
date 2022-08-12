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
        Kraina.FireBaseManager.shared.getPost(collection: "\(FireBaseCollectionsEnum.castles)", docName: "\(FireBaseCastlesEnum.bihovskiyZamok)") { doc in
            guard let docUnwrapped = doc else {return}
            
            self.documentArray.append(docUnwrapped)
            self.adressLabel.text = docUnwrapped.adress
            self.longtitudeLabel.text = docUnwrapped.longtitude
            self.latitudeLabel.text = docUnwrapped.latitude
            self.nameLabel.text = docUnwrapped.name
        }
        
        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.castles)", completion: { models in
            guard let Id = models.first?.documentID,
                  let modelData = models.first?.data(),
                  let model = models.first
            else {return}
            
            var imagesDict = modelData.first { key, value in
                return key.contains("images")
            }
            
            let imagesUrlArray = FireBaseManager.shared.getImagesPathArray(model: model)
            
            for imagesUrl in imagesUrlArray {
                guard let url = URL(string: imagesUrl),
                      let data = try? Data(contentsOf: url) else {return}
                self.picture.image = UIImage(data: data)
            }
            
            self.descriptionLabel.text = Id
            
            
        })
    }
}

//kraina-761cd.appspot.com/castles/bihovskiyZamok/bihovskiyZamok1.jpeg
