//
//  Checker.swift
//  Navigation
//
//  Created by Олеся on 19.06.2022.
//

import Foundation

final class Checker {
    static let shared = Checker()
    private let loginVC = "Вжик"
    private let passwordVC = "Вжик"
    private init () {}
    
    func checkLogData(login: String, password: String) -> Bool {
        login == loginVC && password == passwordVC
    }
}
