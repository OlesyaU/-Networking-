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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTap(_sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var jsonTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    lazy var planetLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    lazy var residentsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .gray
        tableView.separatorStyle = .singleLineEtched
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ModelInfo().getJsonInfo({ [weak self] text in
            DispatchQueue.main.async {
                self?.jsonTitleLabel.text = "Title text is: \n \"\(String(describing: text!.capitalized))\""
            }
        })
        
        ModelInfo().getPlanetaData { [weak self] period in
            guard let period else {return}
            DispatchQueue.main.async {
                self?.planetLabel.text = "Planet orbital period is \(period)"
            }
        }
    }
    
    private func layout() {
        view.backgroundColor = .systemYellow
        [goToAlertButton, jsonTitleLabel, planetLabel, residentsTableView].forEach({view.addSubview($0)})
        NSLayoutConstraint.activate([
            goToAlertButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            goToAlertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            goToAlertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            goToAlertButton.heightAnchor.constraint(equalToConstant: 30),
            
            jsonTitleLabel.topAnchor.constraint(equalTo: goToAlertButton.bottomAnchor, constant: 16),
            jsonTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            jsonTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            jsonTitleLabel.heightAnchor.constraint(equalToConstant: 100),
            
            planetLabel.topAnchor.constraint(equalTo: jsonTitleLabel.bottomAnchor, constant: 16),
            planetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            planetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            planetLabel.heightAnchor.constraint(equalToConstant: 50),
            
            residentsTableView.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 16),
            residentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            residentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            residentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
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
