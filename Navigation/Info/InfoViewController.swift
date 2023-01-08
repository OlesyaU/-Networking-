//
//  InfoViewController.swift
//  Navigation
//
//  Created by Олеся on 15.03.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    lazy var goToAlertButton: CustomButton = {
        let button = CustomButton(title: "Push on me", background: .systemCyan, titleColor: .white)
        button.frame = CGRect(origin: CGPoint(x: 100, y: 150), size: CGSize(width: 150, height: 30))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTap(_sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        view.addSubview(goToAlertButton)
    }
    
    @objc private func buttonTap(_sender: UIButton) {
        let alert = UIAlertController(title: "OOPS", message: "Something wrong!Run!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "I understand", style: .cancel, handler:  {
            _ in print("I understand")
        }))
        alert.addAction(UIAlertAction(title: "I need more info", style: .destructive, handler: {  _ in print("I need more info")
        }))
        self.present(alert, animated: true, completion: {
            print("Info button tapped")
        })
    }
}
