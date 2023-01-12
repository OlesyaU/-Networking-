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
}

