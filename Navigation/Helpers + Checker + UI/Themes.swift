//
//  ProtocolForThemes.swift
//  Navigation
//
//  Created by Олеся on 12.05.2023.
//

import Foundation
import UIKit

protocol SetThemeColorProtocol {
    func setColor()
}

extension UIColor {
    private static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}

extension UIColor {
    static let themeColor = UIColor.createColor(lightMode: .systemMint, darkMode: .systemPink)
    static let buttonColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .blue)
    static let textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
    static let labelColor = UIColor.createColor(lightMode: .clear, darkMode: .gray)
    
}








//структура для использования из кода
struct Pallete {
    enum Theme {
        case light
        case dark
    }
    var main: UIColor
    var labelColor: UIColor
    var button: UIColor
    var textColor: UIColor
    
    static let light = Pallete(main: .white, labelColor: .lightGray, button: .darkGray, textColor: .black)
    static let dark = Pallete(main: .darkGray, labelColor: .clear , button: .lightGray, textColor: .white)
    
}
