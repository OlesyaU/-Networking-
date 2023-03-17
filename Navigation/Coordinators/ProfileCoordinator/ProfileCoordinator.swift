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
    
    private var user: (() -> User)?
    private  let loginVC: LogInViewController
    private var profileNC: UINavigationController
    private let checkerService = CheckerService()
//    private let service = TestUserService()
    var errors: VCErrors?
    var controller: UIViewController
    var children: [Coordinator]
//    var login: (()->String)?
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
//        self.checkResult = loginVC.getRes
    }
    
    func setUp()  {
        
        guard let u = user?() else {print("user = nil")
            return
        }

        if ((checkResult?()) != nil) {
            
            present(.profile(u))
            

            print("checkResult Coordinator-true")
        } else {
            let action1 = UIAlertAction(title: "Cancel", style: .cancel)
            let action2 = UIAlertAction(title: "Sign In", style: .destructive) {_ in
            }
           
            let aleartVC = UIAlertController(title: "User not found", message: String(checkResult?() != nil) , preferredStyle: .alert)

            aleartVC.addAction(action1)
            aleartVC.addAction(action2)
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



