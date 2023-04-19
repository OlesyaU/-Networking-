//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Олеся on 07.04.2023.
//

import CoreData
import UIKit
 
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
    
    var favoritesPosts: [FavoritePost] = [] {
        didSet {
            print("\(favoritesPosts.count)")
            isFavorite?(true)
        }
    }
    
    var cdUser: CDUser?

    func reloadPosts(){
        let request = FavoritePost.fetchRequest()
      let favotitePosts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.favoritesPosts = favotitePosts
    }

    func addNewFavoritePost(nameUser: String, image: UIImage, description: String){
        
        persistentContainer.performBackgroundTask { backgroundContext in
            let newFavorite = FavoritePost(context: backgroundContext)
            newFavorite.postAuthor = nameUser
            newFavorite.postImage = image.pngData()
            newFavorite.postDescription = description
            do {
                try? backgroundContext.save()
                
            } catch {
                print(error)
            }
        }
        reloadPosts()
    }

    func deleteFavoritePost(favoritePost: FavoritePost){
        persistentContainer.viewContext.delete(favoritePost)
        saveContext()
        reloadPosts()
    }
}

