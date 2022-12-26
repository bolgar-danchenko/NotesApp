//
//  AddButton.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

class AddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(systemName: "rectangle.stack.badge.plus"), for: .normal)
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonConstraints(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45).isActive = true
    }
}