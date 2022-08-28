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

    func dropShadow(scale: Bool = true, width: Int, height: Int) {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowOffset = CGSize(width: width, height: height)
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            layer.shadowRadius = 3
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    
    func hideView() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self,
                                                        action: #selector(hide))
        swipeDownGesture.direction = .down
        self.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func hide() {
        
        //скрываю попап
        UIView.animate(withDuration: 5) {
            self.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(250)
            }
            self.layoutIfNeeded()
        }
    }
    
}
