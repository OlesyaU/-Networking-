//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Олеся on 07.04.2023.
//

import CoreData
 
class CoreDataManager{
    
    static let shared = CoreDataManager()
    
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

    func saveContext () {
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
    
var favoritesPosts = [FavoritePost]()
    var cdUser: CDUser?

    func reloadPosts(){
        let request = FavoritePost.fetchRequest()
     
        let favotitePosts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.favoritesPosts = favotitePosts
    }

    func addNewFavoritePost(nameUser: String, image: Data, description: String){
        let newFavorite = FavoritePost(context: persistentContainer.viewContext)
        newFavorite.postUser = nameUser
        newFavorite.postImage = image
        newFavorite.postDescription = description
        saveContext()
        reloadPosts()
    }

    func deleteFolder(favoritePost: FavoritePost){
        persistentContainer.viewContext.delete(favoritePost)
        saveContext()
        reloadPosts()
    }
}

