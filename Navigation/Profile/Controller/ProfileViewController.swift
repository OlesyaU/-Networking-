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
    
    enum ShowContent{
        case allUserInfo
        case favoritePosts
    }
    private let posts =  Post.posts()
    private let filter = ImageProcessor()
    private var user: UserService?
    var nameFromLogin: (() -> String)?
    var coordinator: ProfileCoordinator?
    private let coreDataManager = CoreDataManager.shared
    var setContent: ShowContent = .allUserInfo
    
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
//#if DEBUG
//        self.user = TestUserService()
//#else
//        self.user = CurrentUserService()
//#endif
        self.user = user
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
//        title = "Profile"
        layout()
//        setInfo(withCase: .allUserInfo)
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
//    
//    func setInfo(withCase: ShowContent) {
//        switch withCase {
//            case .allUserInfo:
//                title = "Profile"
//              
//                print(" case вся информация Юзера")
//            case .favoritePosts:
//              
//                print(" case .favoritePosts")
//        }
//    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0, setContent == .allUserInfo {
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
        
        if  indexPath.row == 0, setContent == .allUserInfo {
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
        if setContent == .allUserInfo {
            return header
        } else {
            return nil
        }
    }
}
