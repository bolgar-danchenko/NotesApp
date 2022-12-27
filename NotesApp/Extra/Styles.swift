//
//  Styles.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 27.12.2022.
//

import UIKit

class Styles {
    
    static let colorStrings: [String] = ["Purple", "Blue", "Green", "Orange", "Sand"]
    
    static let customTitleFont: UIFont = UIFont(name: "KronaOne-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
    static let customTextFont: UIFont = UIFont(name: "KronaOne-Regular", size: 14) ?? UIFont.systemFont(ofSize: 12)
    static let customDateFont: UIFont = UIFont(name: "KronaOne-Regular", size: 12) ?? UIFont.systemFont(ofSize: 10)
    
}

extension UILabel {
    func applyStyle(font: UIFont, color: UIColor) {
        self.font = font
        self.textColor = color
    }
}
