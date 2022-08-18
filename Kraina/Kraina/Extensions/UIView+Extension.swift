//
//  UIView+Extension.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 5.08.22.
//

import Foundation
import UIKit

extension UIView{
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 203.0/255.0, green: 239.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor, UIColor(red: 28.0/255.0, green: 151.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.masksToBounds = true
    }
}
