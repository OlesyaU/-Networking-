//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Олеся on 27.09.2022.
//

import UIKit
import RealmSwift

final class MainCoordinator: Coordinator {
    
    var controller: UIViewController
    var children: [Coordinator] = []
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func setUp() {
        if controller is UINavigationController {
            let vc = MainTabBarController()
            vc.coordinator = self
            
            let feedModel = FeedModel()
            let feedViewModel = FeedViewModel(model: feedModel)
            let feedCoordinator = FeedCoordinator(controller: controller)
            let feedVC =  FeedViewController(viewModel: feedViewModel, coordinator: feedCoordinator)
            feedVC.coordinator = feedCoordinator
            feedVC.tabBarItem.image = UIImage(systemName: "rectangle.on.rectangle")
            
            let factory = MyLoginFactory()
            let loginVC = factory.loginViewController()
            loginVC.coordinator = ProfileCoordinator(controller: controller)
            loginVC.tabBarItem.image = .init(systemName: "person")
            loginVC.tabBarItem.title = "Profile"
            
            vc.viewControllers = [feedVC, loginVC]
            
            let nvc = controller as! UINavigationController
            nvc.pushViewController(vc, animated: false)
            
        }
    }
}

