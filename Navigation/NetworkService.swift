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
//        print(url)
        switch configuration {
            case .config1(let url):
                urlA = url
                print("url from switch Network config1 - \(urlA)")
//                return url
            case .config2(let url):
                urlA = url
                print("url from switch Network config2 - \(urlA)")
//                return url
            case .config3(let url):
                urlA = url
                print("url from switch Network  config3 - \(urlA)")
//                return url
        }
//        print("print from Network \(configuration.bnh()) ")
    }
}
