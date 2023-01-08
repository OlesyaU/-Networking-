//
//  User.swift
//  Navigation
//
//  Created by Олеся on 12.06.2022.
//

import Foundation
import UIKit

final class User: UserService {
    func getUser(name: String) -> User? {
        self
    }
// тут я подписала класс юзера на протокол юзер сервис, чтобы удовлетворить в профайлконтроллере условию 
    
    let fullName: String
    let avatar: UIImage
    let status: String
    
    init(fullName: String, avatar: UIImage, status: String) {
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}
