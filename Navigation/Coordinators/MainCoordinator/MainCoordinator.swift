//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Олеся on 27.09.2022.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var controller: UIViewController
    var children: [Coordinator] = []
    
    init(controller: UIViewController){
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
            let profileVC = factory.loginViewController()
            profileVC.coordinator = ProfileCoordinator(controller: controller)
            profileVC.tabBarItem.image = .init(systemName: "person")
            profileVC.tabBarItem.title = "Profile"
            
            vc.viewControllers = [feedVC, profileVC]
            
            let nvc = controller as! UINavigationController
            nvc.pushViewController(vc, animated: false)
            
        }
    }
}

