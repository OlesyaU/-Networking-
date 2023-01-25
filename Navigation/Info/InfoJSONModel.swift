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
struct ModelInfo {
    
    func getJsonInfo(_ completin: ((String)-> Void)?) {
        let session = URLSession(configuration: .default)
        guard let URL = URL(string: "https://jsonplaceholder.typicode.com/todos/") else {return}
        let task = session.dataTask(with: URL) { data, responce, error in
            if let error {
                print(error.localizedDescription)
            }
            let statusCode = (responce as? HTTPURLResponse)?.statusCode
            
            if statusCode != 200 {
                print("Status code != 200. StatusCode = \(String(describing: statusCode))")
                return
                
            }
            
           guard let data  else {
                print("Data = nil")
               return
            }
            
            do {
                guard let answer = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print ("Error parcing json answer")
                    return
                }
                let text = answer["title"]
//                guard let result =  answer["result"] as? [String: Any] else { print ("Error parcing json result ")
//                    return
//                }
//
//                var resultArray: [String] = []
//
//                for item in result {
//                    if let joketext = item["value"] as? String {
//                        resultArray.append(joketext)
//                    }
//                }
       
                
            }
            catch {
                print(error)
            }
        }
    }
    
}
