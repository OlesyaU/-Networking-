//
//  LoginInspector.swift
//  Navigation
//
//  Created by Олеся on 19.06.2022.
//

import Foundation

class LoginInspector: LogInViewControllerDelegate {
    
    
//    let checker = Checker.shared
//    
//    func checkLogData(login: String, password: String) -> Bool{
//      return  checker.checkLogData(login: login , password: password)
//    }
    
    let checkerServise = CheckerService.shared
    var isSignUp = true
    var errorText: String?
    func checkCredentials(login: String, password: String)  {
        checkerServise.checkCredentials(login: login, password: password)
        print("LoginInspector - checkCredentials")
    }
    
    func signUp(login: String, password: String) {
        checkerServise.signUp(login: login, password: password)
        print("LoginInspector - signUp")
    }
}
