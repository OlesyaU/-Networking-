//
//  LoginInspector.swift
//  Navigation
//
//  Created by Олеся on 19.06.2022.
//

import Foundation

//class LoginInspector: LogInViewControllerDelegate {
//
//    let checkerServise = CheckerService.shared
//
////    func checkCredentials(login: String, password: String, completion: ((_ isSignUp: Bool,_ user: User, _ errorText: String)-> Void)?)  {
////        checkerServise.checkCredentials(login: login, password: password, completion: completion)
////        print("LoginInspector - checkCredentials worked")
////    }
//
//    func signUp(login: String, password: String) {
//        checkerServise.signUp(login: login, password: password)
//        print("LoginInspector - signUp worked")
//    }
//}


class LoginInspector: LogInViewControllerDelegate {

    var checkerServise: CheckerServiceProtocol?
//    func checkCredentials(login: String, password: String, completion: ((_ isSignUp: Bool,_ user: User, _ errorText: String)-> Void)?)  {
//        checkerServise.checkCredentials(login: login, password: password, completion: completion)
//        print("LoginInspector - checkCredentials worked")
//    }

    func signUp(login: String, password: String) {
//        checkerServise.signUp(login: login, password: password)
        checkerServise?.signUp(login: login, password: password)
        print("LoginInspector - signUp worked")
    }
}
