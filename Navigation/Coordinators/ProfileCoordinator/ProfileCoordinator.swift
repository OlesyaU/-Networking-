//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Олеся on 28.09.2022.
//

import UIKit
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
    var user: (() -> User)?
    var checkResult:(() -> Bool)?
  var textError: (()-> String)?
    
    
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
    }
    
    func setUp()  {
       if checkResult!() {
            present(.profile(user!()))
           print("checkResult Coordinator-true")
        } else {
            let aleartVC = UIAlertController(title: "OOOOOPS", message: textError!() , preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Cancel", style: .cancel)
//            {
//                _ in
//                self.loginVC.logInButton.isEnabled = false
//                return
//            }
          
            switch textError!(){
                case "":
                    fallthrough
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    let action2 = UIAlertAction(title: "Sign In", style: .destructive) {_ in
                        self.loginVC.delegate?.signUp(login: self.loginVC.getName(), password: self.loginVC.getPassword())
                    }
                   aleartVC.addAction(action2)
                default:
          ()
            }
            
            aleartVC.addAction(action1)
            controller.present(aleartVC, animated: true)
        }
    }
    
    func present(_ presentation: Presentation) {
        switch presentation {
            case .profile(let user):
                let profileVC = ProfileViewController(user: user)
                profileVC.coordinator = self
                profileVC.nameFromLogin = {
                    user.fullName
                }
                controller.navigationController?.pushViewController(profileVC, animated: true)
            case .photos:
                controller.navigationController?.pushViewController(PhotosViewController(), animated: true)
        }
    }

}



