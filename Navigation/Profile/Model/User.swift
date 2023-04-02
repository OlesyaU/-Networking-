//
//  User.swift
//  Navigation
//
//  Created by Олеся on 12.06.2022.
//

import Foundation
import UIKit
import RealmSwift

final class User: Object, UserService {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var email = ""
    @Persisted var password = ""
    @Persisted var isLogin = false
    
    var fullName: String?
    var avatar: UIImage?
    var status: String?
    
    convenience init(email: String,password: String) {
        self.init()
        self.email = email
        self.password = password
        self.isLogin = isLogin
    }
    
    func getUser(name: String) -> User? {
        self
    }
}
// тут я подписала класс юзера на протокол юзер сервис, чтобы удовлетворить в профайлконтроллере условию
