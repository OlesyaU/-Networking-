//
//  WrongViewController.swift
//  Navigation
//
//  Created by Олеся on 17.10.2022.
//

import UIKit

final class WrongViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        button.backgroundColor = .green
        button.setTitle("Back/dismiss/pop", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        navigationController?.title = "It's wrong VC or ELSE vc"
        view.addSubview(button)
    }
    
    
    @objc private func buttonTap(){
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }


}
