//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Олеся on 28.09.2022.
//

import UIKit

final class FeedCoordinator: Coordinator {
    
    //    weak var parentCoordinator: MainCoordinator?
    var controller: UIViewController
    var children: [Coordinator] = []
    var check: (()-> Bool)?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func setUp()  {
        if controller is UINavigationController  {
            let postVC = PostViewController()
            let nvc =  controller as! UINavigationController
            if check!() == true  {
                nvc.pushViewController(postVC, animated: true)
            } else {
                let alert = UIAlertController(title: "Incorrect or NO data ", message: "You didn't write right password. Change this please to continue. Correct password is \"Password\"" , preferredStyle: .alert)
                let act = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(act)
                controller.present(alert, animated: true)
            }
        }
    }
}

//тут я специально сделала в методе ветвление, на случай если будут разные сценарии в зависимости от того, ввел ли корректно юзер данные или нет. (Кодовое слово - Password)

