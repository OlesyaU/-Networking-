//
//  CheckerService.swift
//  Navigation
//
//  Created by Олеся on 15.03.2023.
//

import Foundation
import RealmSwift

final class CheckerService {
    var realm = try! Realm()
    
    static let shared = CheckerService()
    
    //    func checkCredentials(login: String, password: String,  completion: ((_ isSignUp: Bool,_ user: User, _ errorText: String)-> Void)?)  {
    ////        print("Login CheckerService - checkCredentials \(login)")
    ////        print("Password CheckerService - checkCredentials \(password)")
    ////
    //////       let users = realm.objects(User.self)
    //////        let use = users.where {
    //////            $0.email == login
    //////            $0.password == password
    //////
    //////            return $0.isLogin
    //////
    //////   }
    ////
    //////        print(users)
    //////        completion?(true, User(email: "a@a.ru", password: "aaaaaa"), "no errorText")
    ////     print("CHHEECKK")
    //
    //
    //    }
    
    func signUp(login: String, password: String){
        let user = User(email: login, password: password)
        user.fullName = "Ted"
        user.status = "Hello"
//        user.avatar = UIImage(named: "Томас")
        user.isLogin = true
        try!  realm.write {
            realm.add(user)
        }
        
        print("new user id \(user._id)")
    }
}

