//
//  MyFloatingPanelLayoutClass.swift
//  Kraina
//
//  Created by Максим Журавлев on 2.09.22.
//

//MARK: - Класс для работы с выдвигающимися менюшками
import Foundation
import FloatingPanel

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            //.full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 200, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 30.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
