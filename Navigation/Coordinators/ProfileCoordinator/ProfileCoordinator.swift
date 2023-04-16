//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Олеся on 28.09.2022.
//

import UIKit
import RealmSwift

final class ProfileCoordinator: Coordinator {
    
    enum Presentation {
        case profile(User)
        case photos
    }
    
    private  let loginVC: LogInViewController
    private var profileNC: UINavigationController
    var errors: VCErrors?
    var controller: UIViewController
    var children: [Coordinator]
    var user: User!
    
    var checkResult:(() -> Bool)?
    var textError:(() -> String)?
    var realm = try! Realm()
    var users: Results<User>
    
   init(controller: UIViewController) {
        self.controller = controller
        children = []
        
        let factory = MyLoginFactory()
        loginVC = factory.loginViewController()
        
        // create tab bar with profile items
        profileNC = UINavigationController(rootViewController: loginVC)
        profileNC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person.crop.circle"),
                                            selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        users = try! realm.objects(User.self)
       user = users.last

       print("User from coord \(user)")
       if user != nil,  user.isLogin == true {
           present(.profile(user))
       
       }
       
       
//       else {
//           let aleartVC = UIAlertController(title: "OOOOOPS", message: textError?() , preferredStyle: .alert)
//           let action2 = UIAlertAction(title: "Sign In", style: .destructive) {_ in
//               self.loginVC.delegate?.signUp(login: self.loginVC.getName(), password: self.loginVC.getPassword())
//           }
//           aleartVC.addAction(action2)
//           controller.present(aleartVC, animated: true)
//       }
    }
    
    func setUp(){
        if user != nil, user.isLogin == true {
            present(.profile(user))
            print("user from setUp \(user)")
        } else {
            let aleartVC = UIAlertController(title: "OOOOOPS", message: textError?() , preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Cancel", style: .cancel)
            
            switch textError?(){
                case "":
                    fallthrough
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    let action2 = UIAlertAction(title: "Sign In", style: .destructive) {_ in
                        self.loginVC.delegate?.signUp(login: self.loginVC.getName(), password: self.loginVC.getPassword())
                    }
                    aleartVC.addAction(action2)
                default:
                    aleartVC.addAction(action1)
            }
            controller.present(aleartVC, animated: true)
        }
    }
    
    func present(_ presentation: Presentation) {
        switch presentation {
            case .profile(let user):
                let profileVC = ProfileViewController(user: user)
                profileVC.coordinator = self
                profileVC.setContent = .allUserInfo
                profileVC.nameFromLogin = {
                    user.fullName ?? "No name yet"
                }
               controller.navigationController?.pushViewController(profileVC, animated: true)
        
            case .photos:
                controller.navigationController?.pushViewController(PhotosViewController(), animated: true)
        }
    }
}



