//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Олеся on 14.03.2022.
//

import UIKit
import StorageService
import iOSIntPackage

protocol UserService: AnyObject {
    func getUser(name: String) -> User?
}

class ProfileViewController: UIViewController {
    
    private let posts =  Post.posts()
    private let filter = ImageProcessor()
    private let user: UserService?
    var nameFromLogin: (() -> String)?
    var coordinator: ProfileCoordinator?
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemGray4
        table.dataSource = self
        table.delegate = self
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        return table
    }()
    
    init(user: UserService) {
#if DEBUG
        self.user = TestUserService()
#else
        self.user = CurrentUserService()
#endif
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
#if DEBUG
        view.backgroundColor = .red
#else
        view.backgroundColor = .cyan
#endif
        title = "Profile"
        layout()
    }
    
    private func layout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            navigationController?.pushViewController(PhotosViewController(), animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        guard let firstCell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as?  PhotosTableViewCell else {return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        
        if  indexPath.row == 0 {
            firstCell.configure(photos: Photo.getPhotos())
            return firstCell
        } else {
            var originImage = UIImage(named: post.image)
            switch indexPath.row {
                case 1:
                    filter.processImage(sourceImage: originImage!, filter: .colorInvert) { filtered in originImage = filtered }
                case 2:
                    filter.processImage(sourceImage: originImage!, filter: .noir) { filtered in
                        originImage = filtered
                        //                        cell.configure(post: post)
                    }
                case 3:
                    filter.processImage(sourceImage: originImage!, filter: .chrome) { filtered in   originImage =  filtered }
                    //                    cell.configure(post: post)
                default:
                    print("its default case from ProfileVC with index \(indexPath.row)")
            }
            cell.configure(post: post)
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let name = nameFromLogin?() ?? "no name Profile VC"
        let header = ProfileHeaderView(frame: .zero)
        guard let user = user?.getUser(name: name) else { return nil}
        header.configure(user: user)
        return header
    }
}
