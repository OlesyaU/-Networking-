//
//  CheckerService.swift
//  Navigation
//
//  Created by Олеся on 15.03.2023.
//

import Foundation
import RealmSwift

protocol CheckerServiceProtocol: AnyObject {
    func signUp(login: String, password: String)
}

final class CheckerService: CheckerServiceProtocol {
    var realm = try! Realm()

    static let shared = CheckerService()

    func signUp(login: String, password: String) {
        let user = User(email: login, password: password)
        user.fullName = "Ted"
        user.status = "Hello"
//        user.avatar = UIImage(named: "Томас")
        user.isLogin = true

        try! realm.write {
            realm.add(user)
        }

        print("new user id \(user._id)")
    }
}

