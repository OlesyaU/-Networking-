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

class ProfileViewController: UIViewController, FavoritePostDelegate {
    func favoritePostTap(bool: Bool) {
        if bool {
            DispatchQueue.main.async {
                self.navigationItem.setRightBarButton(.init(title: "♥️", style: .plain, target: self, action: #selector(self.self.rightButtonTapped)), animated: true)

                self.coreDataManager.reloadPosts()
            }
}
    }
    
    
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
    var mainCoord: MainCoordinator?
    
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
      
        layout()
        //        setInfo(withCase: .allUserInfo)
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setRightBarButton(.init(title: "♥️", style: .plain, target: self, action: #selector(rightButtonTapped)), animated: true)
        navigationItem.setLeftBarButton(.init(title: "Выйти", style: .plain, target: self, action: #selector(leftButtonTapped)), animated: true)
        if coreDataManager.favoritesPosts == [] {
 navigationItem.rightBarButtonItem = nil
        }
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if coreDataManager.favoritesPosts == [] {
            mainCoord?.setUp()
        }
    }
    @objc func leftButtonTapped(){
        user = nil
        coordinator?.user = user as? User
        if coreDataManager.favoritesPosts != [] {
            mainCoord?.setUp()
        }
//        mainCoord?.setUp()
 navigationController?.popViewController(animated: true)
        
   }
    @objc func rightButtonTapped(){

        setContent = .favoritePosts

        coreDataManager.reloadPosts()
        tableView.reloadData()
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
        if indexPath.row == 0, setContent == .allUserInfo {
            navigationController?.pushViewController(PhotosViewController(), animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setContent == .allUserInfo {
            navigationController?.isNavigationBarHidden = false
          title = "Profile"
            return posts.count
        } else {
            title = "Favorites"
           return coreDataManager.favoritesPosts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        guard let firstCell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as?  PhotosTableViewCell else {return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        if  indexPath.row == 0, setContent == .allUserInfo {
            firstCell.configure(photos: Photo.getPhotos())
            return firstCell
        } else  if  setContent == .allUserInfo {
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
            cell.delegate = self
            cell.configure(post: post)
           
            return cell
        } else if setContent == .favoritePosts {
    self.navigationItem.leftBarButtonItem = .init(title: "Choose", style: .plain, target: self, action: #selector(chooseButtonPressed))
            self.navigationItem.rightBarButtonItem = .init(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
            let favoritePost = coreDataManager.favoritesPosts[indexPath.row]
            cell.configureFavorite(favoritePost: favoritePost)
        }
        return cell
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
extension ProfileViewController {

   @objc func chooseButtonPressed(){
        print("CHOOSE BUTTON PRESSSSEEDD")
    }
    @objc func cancelButtonPressed() {
        print("CAANNCCEELL BUTTON PRESSSSEEDD")
    }
}
