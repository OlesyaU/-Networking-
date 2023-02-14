//
//  InfoJSONModel.swift
//  Navigation
//
//  Created by Олеся on 26.01.2023.
//

import Foundation
//JSON для первого
//для первого задания JSON
/*
 "userId": 1,
 "id": 1,
 "title": "delectus aut autem",
 "completed": false
 */
//для второго  и третьего заданий JSON
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
struct Resident: Decodable {
    var name: String
}

struct Planeta: Decodable {
    var name: String
    var period: String
    var residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case period = "orbital_period"
        case residents
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
                //  тут берем тайтл у рандомного JSON'a - это можно изменить
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
    
    static func getPlaneta() async throws -> Planeta {
        let url = URL(string: "https://swapi.dev/api/planets/1")!
        let planeta = try await URLSession.shared.decode(Planeta.self, from: url)
         return planeta
        
   }
    
  static func getPlanetResidents() async throws -> Planeta {
//        guard
            let url = URL(string: "https://swapi.dev/api/planets/1/")!
//       else {
//            print("проблема с урлом")
//            return
//        }
       let planeta = try await URLSession.shared.decode(Planeta.self, from: url)
        return planeta
//        let session = URLSession(configuration: .default)
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 0)
//        let task = session.dataTask(with: request) { data, response, error in
//            if let error {
//                print(error.localizedDescription)
//                completion?(nil)
//                return
//            }
//
//            let statusCode = (response as? HTTPURLResponse)?.statusCode
//
//            if statusCode != 200 {
//                print("Status code isn't 200, statusCode \(String(describing: statusCode))")
//                completion?(nil)
//                return
//            }
//
//            guard let data  else {
//                print("data - nil")
//                completion?(nil)
//                return
//            }
//
//            do {
//                let answer = try JSONDecoder().decode(Planeta.self, from: data)
//
//                //         массив резидентов тут        answer.residents
//                var answerArray: [String] = []
//
//                for item in answer.residents {
//                    answerArray.append(item)
//                }
//
//                completion?(answerArray)
//            }
//            catch {
//                completion?(nil)
//                print(error)
//            }
//        }
//
//        //        не забываем резьюмить таску!
//        task.resume()
    }
    
    func getPlanetResident(urlResident: String, completion: ((Resident?)-> Void)?){
        let session = URLSession(configuration: .default)
        
        guard let URL = URL(string: urlResident) else {return}
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
            print(data)
            do {
                let answer =  try JSONDecoder().decode(Resident.self, from: data)
                completion?(answer)
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

extension URLSession {
    func decode<T: Decodable>(
        _ type: T.Type = T.self,
        from url: URL,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    ) async throws -> T {
        let (data, _) = try await data(from: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}
