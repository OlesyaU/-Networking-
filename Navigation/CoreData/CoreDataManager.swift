//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Олеся on 07.04.2023.
//

import CoreData
import UIKit
import StorageService
 
class CoreDataManager{
    
    static let shared = CoreDataManager()
    var isFavorite: ((Bool)-> Void)?
    
    init(){
        reloadPosts()
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FavoritePost")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   //MARK: - CDUser, FavoritesPosts - CoreData
    
    var favoritesPosts: [FavoritePost] = [] 
    
    var cdUser: CDUser?

    func reloadPosts(){
        let request = FavoritePost.fetchRequest()
      let favotitePosts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.favoritesPosts = favotitePosts
    }
    func addFavoritePost(post: Post?, completion: @escaping ()-> Void) {
        guard let post else {
            print("Post in CoreDataManeger not found")
            return
        }
        persistentContainer.performBackgroundTask { bacgroundContext in
            let favoritePost = FavoritePost(context: bacgroundContext)
            favoritePost.postAuthor = post.author
            favoritePost.postDescription = post.description
            favoritePost.postImage = UIImage(named: post.image)?.pngData()
            favoritePost.likes = Int64(post.likes)
            favoritePost.views = Int64(post.views)
            favoritePost.isLiked = post.isLiked
            favoritePost.id = post.id
            self.isFavorite?(post.isLiked)
            do {
                try bacgroundContext.save()
            } catch{
                print(error)
            }
            print(post)
            completion()
        }
        reloadPosts()
    }

//    func addNewFavoritePost(nameUser: String, image: UIImage, description: String){
//        persistentContainer.performBackgroundTask { backgroundContext in
//            let newFavorite = FavoritePost(context: backgroundContext)
//            newFavorite.postAuthor = nameUser
//            newFavorite.postImage = image.pngData()
//            newFavorite.postDescription = description
//            do {
//                try? backgroundContext.save()
//
//            } catch {
//                print(error)
//            }
//        }
//        reloadPosts()
//    }

    func deleteFavoritePost(favoritePost: FavoritePost){
        persistentContainer.viewContext.delete(favoritePost)
        saveContext()
        reloadPosts()
    }
    func getFavoritePost(postAuthor: String? = nil) -> [FavoritePost] {
        print(postAuthor)
        let fetchRequest = FavoritePost.fetchRequest()
        if let postAuthor, postAuthor != "" {
          fetchRequest.predicate = NSPredicate(format: "postAuthor contains[c] %@ ", postAuthor)
        }
        
        return (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
    }
}

