//
//  LocalizedHelper.swift
//  Navigation
//
//  Created by Олеся on 12.05.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
