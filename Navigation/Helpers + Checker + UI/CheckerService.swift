//
//  CheckerService.swift
//  Navigation
//
//  Created by Олеся on 15.03.2023.
//

import Foundation
import FirebaseAuth

final class CheckerService {
    static let shared = CheckerService()
    var isSignUp: Bool = false
    var errorText: String?
    
    func checkCredentials(login: String, password: String)  {
        print("Login CheckerService - checkCredentials \(login)")
        print("Password CheckerService - checkCredentials \(password)")
        Auth.auth().signIn(withEmail: login, password: password) { result, error in
            guard result != nil else {
                self.signUp(login: login, password: password)
                self.isSignUp = false
                self.errorText = error?.localizedDescription
                print("user in checkCredentals not found")
                print(error?.localizedDescription as Any)
                print(self.isSignUp)
                return
            }
            print("User in DataBase - checkCredentials")
            self.isSignUp = true
            print(self.isSignUp)
        }
    }
    
    func signUp(login: String, password: String){
        Auth.auth().createUser(withEmail: login, password: password) { result, error in
        }
    }
}
//если на экране отрисована лишь одна кнопка Login, то необходимо продумать логику регистрации пользователя. При нажатии на неё сначала проверять, есть ли такой пользователь в БД:
//если такого пользователя нет, регистировать в БД;
//если такой пользователь есть, но введён неверный пароль, показать соответствующую ошибку;
//если пользователь есть, а введённые поля валидны, проходить авторизацию и открывать следующий экран
