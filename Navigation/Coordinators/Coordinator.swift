//
//  Coordinator.swift
//  Navigation
//
//  Created by Олеся on 02.10.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    var controller: UIViewController { get set }
    var children: [Coordinator] { get set }
    func setUp()
}

