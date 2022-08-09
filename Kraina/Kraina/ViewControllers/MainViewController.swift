//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
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
        FireBaseManager.shared.getPost(collection: "cars", docName: "smallCar") { doc in
            guard doc != nil else {return}
            self.label1.text = doc?.field1
            self.label2.text = doc?.field2
        }
        FireBaseManager.shared.getImage(picName: "clouds") { image in
            self.picture.image = image
        }
    }
    
    @IBAction func snowAction(_ sender: Any) {
        FireBaseManager.shared.getPost(collection: "cars", docName: "middleCar") { doc in
            guard doc != nil else {return}
            self.label1.text = doc?.field1
            self.label2.text = doc?.field2
        }
        FireBaseManager.shared.getImage(picName: "snow") { image in
            self.picture.image = image
        }
    }
}

