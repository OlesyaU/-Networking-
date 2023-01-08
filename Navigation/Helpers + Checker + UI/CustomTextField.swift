//
//  CustomTextField.swift
//  Navigation
//
//  Created by Олеся on 02.07.2022.
//

import UIKit

final class CustomTextField : UITextField {
    
    required init(borderStyle: BorderStyle, clearButton : ViewMode, color: UIColor) {
        super.init(frame: .zero)
        setUpTextField(borderStyle: borderStyle, clearButton: clearButton, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextField(borderStyle: BorderStyle, clearButton : ViewMode, color: UIColor) {
        self.textColor = color
        clearButtonMode = clearButton
        self.borderStyle = borderStyle
        layer.cornerRadius = 10
        clipsToBounds = true
        self.autocorrectionType = .no
    }
    
    
}
