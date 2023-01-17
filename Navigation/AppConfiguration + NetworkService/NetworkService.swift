//
//  NetworkService.swift
//  Navigation
//
//  Created by Олеся on 08.01.2023.
//

import Foundation

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        var urlA: URL
        switch configuration {
            case .config1(let url):
                urlA = url
                print("url from switch Network config1 - \(urlA)")
            case .config2(let url):
                urlA = url
                print("url from switch Network config2 - \(urlA)")
            case .config3(let url):
                urlA = url
                print("url from switch Network  config3 - \(urlA)")
        }
        
//        static func urlSession(stringURL: String) {
//               if let url = URL(string: stringURL) {
//                   let task = URLSession.shared.dataTask(with: url) { data, response, error in
//       // можно так - чтобы проще было(в AppConfiguration сделать rawValue и от него уже "плясать" при сборке проекта)
       
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: urlA)
        let task = session.dataTask(with: request) { data, responce, error in
            if let error {
                print(error.localizedDescription)
                return
            }
           
            
            let statusCode = (responce as! HTTPURLResponse).statusCode
            let header = (responce as! HTTPURLResponse).allHeaderFields
            if statusCode != 200 {
                print("Status code isn't 200, statusCode \(String(describing: statusCode))")
                return
            }
            print("STATUS CODE IS \(statusCode)")
            print("ALLHEADER FIELDS IS \(header)")
            
            guard let data else {
                print("data - nil")
                return
            }
            
            do {
                guard let answer =  try JSONSerialization.jsonObject(with: data) as?  [String: Any]  else {
                    print ("Error parcing json answer")
                    return
                }
                guard let name = answer["name"] as? String else {
                    print("trouble with parse JSON")
                    return
                }
                print("SUCSESS PARSE JSON. I wanted print name and it's \(name)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
//текст ошибки "The Internet connection appears to be offline."
