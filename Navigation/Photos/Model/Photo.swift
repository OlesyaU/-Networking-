//
//  Photos.swift
//  Navigation
//
//  Created by Олеся on 16.04.2022.
//

import UIKit

struct Photo {
    let photo: UIImage!
    
    static func getPhotos() -> [UIImage] {
        let array2: [String] = ["шрек", "рио", "рапунцель", "скрудж и крабс", "газ","гном", "джин", "дональд", "дятел Вудди", "кенга", "король лев", "лев Алекс", "львенок", "микки",  "мини", "монстры", "плуто", "птахиРио", "пятачок",  "винни и все", "вжик", "русалочка", "гаечка", "тимон", "чип", "бэмби" ]
        
        var arrayPhoto = [UIImage]()
        if !array2.isEmpty {
            arrayPhoto = array2.map{UIImage(named: $0) ?? UIImage()}
        }
        return arrayPhoto
    }
    static func getDoudlePhotos() -> [UIImage] {
     getPhotos() + getPhotos()
    }
}


