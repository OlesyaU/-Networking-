//
//  InfoJSONModel.swift
//  Navigation
//
//  Created by Олеся on 26.01.2023.
//

import Foundation
//для первого задания JSON
/*
 "userId": 1,
 "id": 1,
 "title": "delectus aut autem",
 "completed": false
 */
//для второго задания JSON
/*
 {
 "name": "Tatooine",
 "rotation_period": "23",
 "orbital_period": "304",
 "diameter": "10465",
 "climate": "arid",
 "gravity": "1 standard",
 "terrain": "desert",
 "surface_water": "1",
 "population": "200000",
 "residents": [
 "https://swapi.dev/api/people/1/",
 "https://swapi.dev/api/people/2/",
 "https://swapi.dev/api/people/4/",
 "https://swapi.dev/api/people/6/",
 "https://swapi.dev/api/people/7/",
 "https://swapi.dev/api/people/8/",
 "https://swapi.dev/api/people/9/",
 "https://swapi.dev/api/people/11/",
 "https://swapi.dev/api/people/43/",
 "https://swapi.dev/api/people/62/"
 ],
 "films": [
 "https://swapi.dev/api/films/1/",
 "https://swapi.dev/api/films/3/",
 "https://swapi.dev/api/films/4/",
 "https://swapi.dev/api/films/5/",
 "https://swapi.dev/api/films/6/"
 ],
 "created": "2014-12-09T13:50:49.641000Z",
 "edited": "2014-12-20T20:58:18.411000Z",
 "url": "https://swapi.dev/api/planets/1/"
 }
 */

struct Planeta: Decodable {
    var name: String
    var period: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case period = "orbital_period"
    }
}

struct ModelInfo {
    
    func getJsonInfo(_ completion: ((_ textTitle: String?)-> Void)?) {
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
    
    func getPlanetaData(_ completion: ((_ period: String?)-> Void)?) {
        let session = URLSession(configuration: .default)
        guard let URL = URL(string: "https://swapi.dev/api/planets/1") else {return}
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
                guard let answer =  try JSONDecoder().decode(Planeta?.self, from: data) else {
                    completion?(nil)
                    print(error)
                    return
                }
                let period = answer.period
                completion?(answer.period)
            }
            catch {
                print(error)
                completion?(nil)
                return
            }
        }
        task.resume()
    }
}
