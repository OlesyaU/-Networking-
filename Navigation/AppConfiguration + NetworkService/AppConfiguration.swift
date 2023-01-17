//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Олеся on 08.01.2023.
//

import Foundation

enum AppConfiguration: CaseIterable {
    static var allCases: [AppConfiguration] = [config1(url: URL(string: "https://swapi.dev/api/people/8")!), config2(url: URL(string: "https://swapi.dev/api/people/5")!), config3(url: URL(string: "https://swapi.dev/api/people/3")!)]
    
    case config1(url:URL)
    case config2(url:URL)
    case config3(url:URL)
}


//вариант чуть более простой реализации рандомной загрузки урла в файле NetworkService продолжение...

//enum AppConfiguration: String, CaseIterable {
//
//    case people = "https://swapi.dev/api/people"
//    case starships = "https://swapi.dev/api/starships"
//    case planets = "https://swapi.dev/api/planets"
//
//    static var stringURL: String {
//        AppConfiguration.allCases.randomElement()!.rawValue
//    }
//}
