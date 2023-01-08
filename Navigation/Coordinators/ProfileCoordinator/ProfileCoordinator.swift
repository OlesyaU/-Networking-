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
    
    private var user: User?
    private  let loginVC: LogInViewController
    private var profileNC: UINavigationController
    private let service = TestUserService()
    var errors: VCErrors?
    var controller: UIViewController
    var children: [Coordinator]
    var login: (()->String)?
    var checkResult: (()->Bool)?
    
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
        user = service.getUser(name: login!())
        guard let user = user else {return}
        if checkResult!() {
            present(.profile(user))
        } else {
            let aleart = UIAlertAction(title: "User not found", style: .destructive)
            let aleartVC = UIAlertController(title: "WTF", message: "Strange thing", preferredStyle: .alert)
            aleartVC.addAction(aleart)
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



