//
//  CustomButton.swift
//  Navigation
//
//  Created by Олеся on 27.06.2022.
//

import UIKit

final class CustomButton: UIButton {
    
    var buttonPressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init(title: String, background: UIColor, titleColor: UIColor) {
        super.init(frame: .zero)
        setUpButton(title: title, background: background, titleColor: titleColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton(title: String, background: UIColor, titleColor: UIColor){
        setTitle(title , for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = background
        layer.cornerRadius = 10
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(){
        buttonPressed?()
    }
}
