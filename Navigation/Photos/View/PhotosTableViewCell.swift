//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Олеся on 16.04.2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Photos"
        return label
    }()
    
    private let arrow : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "направо"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private lazy var image1: UIImageView = makeImageView()
    private lazy var image2: UIImageView = makeImageView()
    private lazy var image3: UIImageView = makeImageView()
    private lazy var image4: UIImageView = makeImageView()
    
    private func makeImageView() -> UIImageView {
        let image =  UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        return image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(photos: [UIImage]) {
        guard photos.count > 3 else  { return }
        image1.image = photos[0]
        image2.image = photos[1]
        image3.image = photos[2]
        image4.image = photos[3]
    }
    private func layout () {
        [label, arrow,image1, image2, image3, image4].forEach{contentView.addSubview($0)}
        
        let constraint: CGFloat = 12
        let heightConst: CGFloat = 8
        let width: CGFloat = (UIScreen.main.bounds.width - ((constraint * 2) + heightConst * 3))/4
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraint),
            label.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -constraint),
            arrow.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint),
            arrow.heightAnchor.constraint(equalTo: label.heightAnchor),
            arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor),
            
            image1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraint),
            image1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: constraint),
            image1.heightAnchor.constraint(equalToConstant: width),
            image1.widthAnchor.constraint(equalToConstant: width),
            image1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constraint),
            
            image2.leadingAnchor.constraint(equalTo: image1.trailingAnchor, constant: heightConst),
            image2.centerYAnchor.constraint(equalTo: image1.centerYAnchor),
            image2.widthAnchor.constraint(equalToConstant: width),
            image2.heightAnchor.constraint(equalToConstant: width),
            
            image3.leadingAnchor.constraint(equalTo: image2.trailingAnchor, constant: heightConst),
            image3.centerYAnchor.constraint(equalTo: image2.centerYAnchor),
            image3.widthAnchor.constraint(equalToConstant: width),
            image3.heightAnchor.constraint(equalToConstant: width),
            
            image4.leadingAnchor.constraint(equalTo: image3.trailingAnchor, constant: heightConst),
            image4.centerYAnchor.constraint(equalTo: image3.centerYAnchor),
            image4.widthAnchor.constraint(equalToConstant: width),
            image4.heightAnchor.constraint(equalToConstant: width),
            image4.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraint)
        ])
    }
}








