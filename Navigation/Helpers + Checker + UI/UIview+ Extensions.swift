//
//  File.swift
//  Navigation
//
//  Created by Олеся on 03.04.2022.
//

import Foundation
import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

final class Helper {
    
  class func showAleart(for viewController: UIViewController, with title: String, action1Title: String, action2Title: String?){
           let aleart = UIAlertController(title: title, message: nil, preferredStyle: .alert)
           let action = UIAlertAction(title: action1Title, style: .destructive)
      if action2Title != nil {
          let action2 = UIAlertAction(title: action2Title, style: .cancel)
          
          aleart.addAction(action2)
      }
           aleart.addAction(action)
        viewController.present(aleart, animated: true)
       }
}


