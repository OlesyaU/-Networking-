//
//  CheckerService.swift
//  Navigation
//
//  Created by Олеся on 15.03.2023.
//

import Foundation
import FirebaseAuth

final class CheckerService {
//    static let shared = CheckerService()
//    private  var loginVC  = ""
//    private  var passwordVC = ""
//    private init () {}
    
    func checkCredentials(){
        Auth.auth().signIn(withEmail: <#T##String#>, password: <#T##String#>) { <#AuthDataResult?#>, <#Error?#> in
            <#code#>
        }
//        при реализации метода checkCredentials проверять, есть ли в БД пользователь с переданными учётными данными, вызывая метод Auth.auth().signIn(withEmail:, password:, completion:);
//        если этот метод вернул ошибку, то показывать её на экране в виде алерта. Регистрировать пользователя с помощью метода Auth.auth().createUser(withEmail:, password:, completion:);
    }
    func signUp(){
        
        Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>) { <#AuthDataResult?#>, <#Error?#> in
            <#code#>
        }
    }
    
}
//если на экране отрисована лишь одна кнопка Login, то необходимо продумать логику регистрации пользователя. При нажатии на неё сначала проверять, есть ли такой пользователь в БД:
//если такого пользователя нет, регистировать в БД;
//если такой пользователь есть, но введён неверный пароль, показать соответствующую ошибку;
//если пользователь есть, а введённые поля валидны, проходить авторизацию и открывать следующий экран
