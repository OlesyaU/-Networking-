//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Олеся on 08.01.2023.
//

import Foundation



enum AppConfiguration: CaseIterable {
    static var allCases: [AppConfiguration] = [config1(url: URL(string: "https://swapi.dev/api/people/8")!), config2(url: URL(string: "https://swapi.dev/api/people/5")!), config3(url: URL(string: "https://swapi.dev/api/people/3")!)]
    

    case config1(url: URL)
    case config2(url: URL)
    case config3(url: URL)

    
//    func bnh () -> URL{
//
//        switch self {
//            case .config1(let url):
//                print("url from switch AppCofig config1 - \(url)")
//                return url
//            case .config2(let url):
//                print("url from switch AppCofig config2 - \(url)")
//                return url
//            case .config3(let url):
//                print("url from switch AppCofig  config3 - \(url)")
//                return url
//        }
//    }
    }
   
//}
//case 1(URL(string: "https://swapi.dev/api/people/8"))
//case 2(URL(string: "https://swapi.dev/api/starships/3"))
//case 3(URL(string: "https://swapi.dev/api/planets/5"))
