//
//  UIView+Extension.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 5.08.22.
//

import Foundation
import UIKit

extension UIView{

      func dropShadow(scale: Bool = true) {
          self.layer.masksToBounds = false
          self.layer.shadowOpacity = 0.4
          self.layer.shadowOffset = CGSize(width: 2, height: 3)
          self.layer.shadowColor = UIColor.black.cgColor
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
