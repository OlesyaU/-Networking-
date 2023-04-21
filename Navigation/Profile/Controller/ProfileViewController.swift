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
    
    private var posts =  Post.posts()
    private let filter = ImageProcessor()
    private var user: UserService?
    var nameFromLogin: (() -> String)?
    var coordinator: ProfileCoordinator?
    private let coreDataManager = CoreDataManager.shared
    var setContent: ShowContent = .allUserInfo
    var mainCoord: MainCoordinator?
//    var favoritePosts = [FavoritePost]()
   
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemGray4
        table.dataSource = self
        table.delegate = self
        table.isMultipleTouchEnabled  = false
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
//        favoritePosts = getFavoritePosts()
        //        setInfo(withCase: .allUserInfo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        favoritePosts = getFavoritePosts()
        if coreDataManager.favoritesPosts.count > 0 {
            navigationItem.setRightBarButton(.init(title: "♥️", style: .plain, target: self, action: #selector(rightButtonTapped)), animated: true)
            navigationItem.setLeftBarButton(.init(title: "Выйти", style: .plain, target: self, action: #selector(leftButtonTapped)), animated: true)
        } else {
            navigationItem.rightBarButtonItem = nil
            navigationItem.setLeftBarButton(.init(title: "Выйти", style: .plain, target: self, action: #selector(leftButtonTapped)), animated: true)
        }
        tableView.reloadData()
    }
    
    @objc func leftButtonTapped(){
        coordinator?.user = user as? User
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
    func getFavoritePosts() -> [FavoritePost] {
        coreDataManager.favoritesPosts
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0, setContent == .allUserInfo {
            navigationController?.pushViewController(PhotosViewController(), animated: true)
        } else {
            favorited(index: indexPath)
        }
       
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            let post = self.coreDataManager.favoritesPosts[indexPath.row]
            self.coreDataManager.deleteFavoritePost(favoritePost: post)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            if self.coreDataManager.favoritesPosts.count == 0 {
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.setLeftBarButton(.init(title: "Выйти", style: .plain, target: self, action: #selector(self.leftButtonTapped)), animated: true)
            }
            print("Deleting. Favorites count is  \(self.coreDataManager.favoritesPosts.count)")
            completionHandler(true)
        }
    return action
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

        if   setContent == .allUserInfo, indexPath.row == 0  {
            
            firstCell.configure(photos: Photo.getPhotos())
            return firstCell
        } else if setContent == .allUserInfo {
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
            let post  = coreDataManager.favoritesPosts[indexPath.row]
            cell.configureFavorite(favoritePost: post)
        }
        return cell
    }
    private func favorited(index: IndexPath) {
        var post = posts[index.row]
        post.isLiked = true
        coreDataManager.addFavoritePost(post: post, completion: {
            print("compl from didSelect")

            if self.coreDataManager.favoritesPosts == [] {
                DispatchQueue.main.async {
                    self.navigationItem.setRightBarButton(.init(title: "♥️", style: .plain, target: self, action: #selector(self.rightButtonTapped)), animated: true)
                    print(self.coreDataManager.favoritesPosts.count)
                    self.tableView.reloadData()
                }
            }
                })
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return .none
    }
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
}

extension ProfileViewController: FavoritePostDelegate {
    func favoritePostTap(bool: Bool) {
        print("favorite post count before tapFavorite \(coreDataManager.favoritesPosts.count)")
            if bool {
                    print("favorite post count after tapFavorite \(coreDataManager.favoritesPosts.count)")
                }
            }

}

extension ProfileViewController {
    
    @objc func chooseButtonPressed(){
     
        let aleart = UIAlertController(title: "Выбрать", message: "Введите имя автора поста", preferredStyle: .alert)
        aleart.addTextField { t in
            t.placeholder = "Имя автора"
            t.clearButtonMode = .whileEditing
        }
        aleart.addAction(UIAlertAction(title: "Начать выбор", style: .destructive, handler: {_ in
            guard  let name = (aleart.textFields?[0].text) else {
                print("name from aleart is lost")
                return
            }
     
            if  name != "" {
                print(name)
            } else {
                print("name from textfield is \(name)")
            }

            DispatchQueue.main.async {
            self.coreDataManager.getFavoritePost(postAuthor: name)
                self.setContent = .favoritePosts
                self.tableView.reloadData()
            }
            print("!!!метод из алерта !!!")
        }))
        self.present(aleart, animated: true)
        print("CHOOSE BUTTON PRESSSSEEDD")
    }
    @objc func cancelButtonPressed() {
        print("CAANNCCEELL BUTTON PRESSSSEEDD")
    }
}
