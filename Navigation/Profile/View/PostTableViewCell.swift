//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Олеся on 02.04.2022.
//

import UIKit
import StorageService

protocol FavoritePostDelegate {
    func favoritePostTap(bool: Bool)
}


class PostTableViewCell: UITableViewCell {
    
    private let coreDataManager = CoreDataManager.shared
    var delegate: FavoritePostDelegate?
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(favoritePost))
        image.isUserInteractionEnabled = true
        image.isMultipleTouchEnabled = true
        gesture.numberOfTapsRequired = 2
        image.addGestureRecognizer(gesture)
        return image
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [image, likesLabel, descriptionLabel, authorLabel, viewsLabel].forEach {contentView.addSubview($0)
        }
        let standartConstraint: CGFloat = 16
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standartConstraint),
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standartConstraint),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standartConstraint),
            
            image.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: standartConstraint),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standartConstraint),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standartConstraint),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: standartConstraint),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standartConstraint),
            likesLabel.trailingAnchor.constraint(equalTo: viewsLabel.leadingAnchor),
            
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: standartConstraint),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standartConstraint),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standartConstraint),
            viewsLabel.widthAnchor.constraint(equalTo: likesLabel.widthAnchor)
        ])
    }
    
    func configure(post: Post) {
        image.image = UIImage(named: post.image)
        authorLabel.text = post.author
        descriptionLabel.text = post.description
//        likesLabel.text = "Likes: \(String(describing: post.likes))"
//        viewsLabel.text = "Views: \(String(describing: post.views))"
        setLikesAndViews(post: post, favoritePost: nil)
    }
    
    func configureFavorite(favoritePost: FavoritePost) {
        image.image = UIImage(data: favoritePost.postImage!)
        authorLabel.text = favoritePost.postAuthor
        descriptionLabel.text = favoritePost.postDescription
//        viewsLabel.text = String("Views: \(favoritePost.views)")
//        likesLabel.text = String("Likes: \(favoritePost.likes)")
        setLikesAndViews(post: nil, favoritePost: favoritePost)
    }
    
    @objc func favoritePost(){
        print("Gesture in Post")
        coreDataManager.isFavorite = { bool in
            print(bool)
            self.delegate?.favoritePostTap(bool: bool)
        }
    }
    private func setLikesAndViews(post: Post?, favoritePost: FavoritePost?) {
        let views = NSLocalizedString("any_views", comment: "")
        let likes = NSLocalizedString("any_likes", comment: "")
        if post != nil {
            viewsLabel.text = String(format: views, post!.views)
            likesLabel.text = String(format: likes, post!.likes)
        } else {
            likesLabel.text = String(format: likes, favoritePost!.likes)
            viewsLabel.text = String(format: views, favoritePost!.views)
        }
    }
}
extension PostTableViewCell: SetThemeColorProtocol {
    func setColor() {
        backgroundColor = .themeColor
//        authorLabel.backgroundColor = .labelColor
        authorLabel.textColor = .textColor
        viewsLabel.textColor = .textColor
        likesLabel.textColor = .textColor
        descriptionLabel.textColor = .textColor
    }
    
    
}
