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
    func checkCredentials(login: String, password: String,  completion: ((_ isSignUp: Bool,_ user: User, _ errorText: String)-> Void)?)  {
        print("Login CheckerService - checkCredentials \(login)")
        print("Password CheckerService - checkCredentials \(password)")

        Auth.auth().signIn(withEmail: login, password: password) { result, error in

                        guard let result  else {
                            self.signUp(login: login, password: password)

                            print("user in checkCredentals not found")

let use = User(fullName: login, avatar: UIImage(), status: "New User")
                            completion?(false, use , error!.localizedDescription)
                            return
                        }
            let us =    User(fullName: result.user.email!, avatar: UIImage(), status: "SDSDF")
                        print("User in DataBase - checkCredentials")
            completion?(true, us, "")
        }
    }
    
    func signUp(login: String, password: String){
        Auth.auth().createUser(withEmail: login, password: password) { result, error in
        }
    }
}

