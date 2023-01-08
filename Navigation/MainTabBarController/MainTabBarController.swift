//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Олеся on 27.09.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = .secondarySystemBackground
        setControllers()
    }
    
    private func setControllers() {
        coordinator?.setUp()
    }
}
