//
//  PostViewController.swift
//  Navigation
//
//  Created by Олеся on 14.03.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        navigationItem.rightBarButtonItem = .init(title: "Info", style: .plain, target: self, action: #selector(barButtonPush))
    }
   
    @objc private func barButtonPush(){
        navigationController?.present(InfoViewController(), animated: true, completion: nil)
    }
    
}
