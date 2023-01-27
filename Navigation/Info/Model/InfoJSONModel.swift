//
//  InfoJSONModel.swift
//  Navigation
//
//  Created by Олеся on 26.01.2023.
//

import Foundation

/*
 "userId": 1,
 "id": 1,
 "title": "delectus aut autem",
 "completed": false
 */
struct JsonInfo {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
struct Answer {
    var json: [JsonInfo]
}

struct ModelInfo {
    
    func getJsonInfo(_ completion: ((_ textTitle:String?)-> Void)?) {
        let session = URLSession(configuration: .default)
        guard let URL = URL(string: "https://jsonplaceholder.typicode.com/todos/") else {return}
        let task = session.dataTask(with: URL) { data, responce, error in
            if let error {
                print(error.localizedDescription)
                completion?(nil)
                return
            }
            let statusCode = (responce as? HTTPURLResponse)?.statusCode
            
            if statusCode != 200 {
                print("Status code != 200. StatusCode = \(String(describing: statusCode))")
                completion?(nil)
                return
            }
            
            guard let data  else {
                print("Data = nil")
                completion?(nil)
                return
            }
            
            do {
                guard let answer = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [[String: Any]] else {
                    print("error parcing JSON")
                    completion?(nil)
                    return
                }
//                тут берем тайтл у рандомного JSON'a - это можно изменить
                guard let text = answer.randomElement()!["title"] as? String else {
                    completion?(nil)
                    return
                }
                
                completion?(text)
            }
            catch {
                print(error)
                completion?(nil)
            }
        }
        task.resume()
    }
}
