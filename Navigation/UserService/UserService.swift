//
//  UserService.swift
//  Navigation
//
//  Created by Олеся on 12.06.2022.
//

import Foundation
import UIKit

final class CurrentUserService: UserService {
    
    var user = User(fullName: "Томас", avatar: UIImage(named: "Томас") ?? UIImage(), status: "Всем привет, я Том!")
    
    func getUser(name: String) -> User? {
        return ( name == user.fullName ? user : User(fullName: name, avatar: UIImage(), status: "Такого пользователя нет"))
    }
}
