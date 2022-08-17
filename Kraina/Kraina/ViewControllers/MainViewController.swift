//
//  ViewController.swift
//  Kraina
//
//  Created by Максим Журавлев on 9.08.22.
//

import UIKit

class MainViewController: UIViewController {
    
    var documentArray: [FireBaseDocument] = []
    var coordinatesArray: [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Главная"
        view.backgroundColor = .white

        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.gray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    override func updateViewConstraints() {

        super.updateViewConstraints()
    }

    }

