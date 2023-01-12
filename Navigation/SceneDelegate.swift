//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Олеся on 10.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var mainCoordinator: MainCoordinator?
    private var appConfiguration: AppConfiguration?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let nav =  UINavigationController()

        mainCoordinator = MainCoordinator(controller: nav)
        mainCoordinator?.setUp()
        setupNavigationBarAppearance()
        networkServiceStart()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
   }
    
    private func setupNavigationBarAppearance(){
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .secondarySystemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    private func networkServiceStart(){
        if !AppConfiguration.allCases.isEmpty {
         appConfiguration = AppConfiguration.allCases.randomElement()!
            let _: () = NetworkService.request(for: appConfiguration!)
//           print("from Scene if not empty \(appConfiguration.debugDescription)")
            print("Start with \(#function)")
        }
}
}

