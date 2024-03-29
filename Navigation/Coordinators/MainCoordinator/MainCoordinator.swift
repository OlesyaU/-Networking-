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
            loginVC.tabBarItem.title = NSLocalizedString("Profile", comment: "")
            loginVC.tabBarController?.tabBar.isHidden = false
            vc.tabBar.isHidden = false
           
            let locationVC = LocationController()
            locationVC.tabBarItem.title = NSLocalizedString("Location", comment: "")
            locationVC.tabBarItem.image = .init(systemName: "map")
            
            guard let user = loginVC.coordinator?.user  else   {
                vc.viewControllers = [feedVC, loginVC, locationVC]
                let nvc = controller as! UINavigationController
                nvc.pushViewController(vc, animated: false)
                print("In MAIN COORDINATOR user is lost")
                return
            }
            print("user from MAIM COORDINATOR \(user)")
            
            let favoritesVC = ProfileViewController(user: user)
            let navFavorite = UINavigationController(rootViewController: favoritesVC)
            favoritesVC.tabBarItem.title = NSLocalizedString("Favorites", comment: "")
            favoritesVC.tabBarItem.image = UIImage(systemName: "heart")
            favoritesVC.setContent = .favoritePosts
            vc.viewControllers = [feedVC, loginVC, navFavorite, locationVC]
            let nvc = controller as! UINavigationController
            nvc.pushViewController(vc, animated: false)
            
        }
    }
}

