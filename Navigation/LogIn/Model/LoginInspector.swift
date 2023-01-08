//
//  LoginInspector.swift
//  Navigation
//
//  Created by Олеся on 19.06.2022.
//

import Foundation

class LoginInspector: LogInViewControllerDelegate {
    
    let checker = Checker.shared
    
    func checkLogData(login: String, password: String) -> Bool{
      return  checker.checkLogData(login: login , password: password) 
    }
}
