//
//  CustomTextView.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

class TextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.translatesAutoresizingMaskIntoConstraints = false
        let font = Styles.customTextFont
        self.font = font
        self.autocorrectionType = .yes
        self.backgroundColor = .clear
        self.textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
