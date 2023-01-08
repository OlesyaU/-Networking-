//
//  TestUserService.swift
//  Navigation
//
//  Created by Олеся on 14.06.2022.
//

import Foundation
import UIKit

final class TestUserService: UserService {
    
    var user = User(fullName: "Вжик", avatar: UIImage(named: "вжик") ?? UIImage(), status: "Всем привет, я Вжик!")
    
    func getUser(name: String) -> User? {
        return ( name == user.fullName ? user : User(fullName: name, avatar: UIImage(), status: "Такого пользователя нет"))
    }
}
