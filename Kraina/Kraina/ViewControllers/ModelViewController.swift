//
//  ModelViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 14.08.22.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class ModelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var model: QueryDocumentSnapshot?
    
    let modelMainTableView: UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = model else {return}
        //title = FireBaseManager.shared.getModelName(model: model)
        
        modelMainTableView.delegate = self
        modelMainTableView.dataSource = self
        modelMainTableView.register(ModelMainTableViewCell.self, forCellReuseIdentifier: ModelMainTableViewCell.identifier)
        
        initialize()
        
    }
    
    private func initialize() {
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        modelMainTableView.frame = view.bounds
       // modelMainTableView.estimatedRowHeight = 85
        modelMainTableView.rowHeight = UITableView.automaticDimension
        modelMainTableView.separatorStyle = .none
        view.addSubview(modelMainTableView)

    }

}

extension ModelViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = modelMainTableView.dequeueReusableCell(withIdentifier: ModelMainTableViewCell.identifier, for: indexPath) as? ModelMainTableViewCell {
            tableCell.model = model
            if let modelUnwrapped = model {
                tableCell.setImage(model: modelUnwrapped)
                tableCell.buttonPressed = {
                          print("PRESSED")
                           }
                
            }
            
            return tableCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


