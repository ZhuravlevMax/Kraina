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
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 3
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    
    // OUTPUT 1
      func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }

      // OUTPUT 2
      func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
            clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
            gradientLayer.frame = self.bounds
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            print(gradientLayer.frame)
            self.layer.insertSublayer(gradientLayer, at: 0)
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
