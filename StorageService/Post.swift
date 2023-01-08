//
//  Post.swift
//  Navigation
//
//  Created by Олеся on 15.03.2022.
//

import Foundation
import UIKit

public struct Post {
    public let author: String
    public var description: String
    public let image: String
    public let likes: Int
    public let views: Int
    
    public static func posts() -> [Post] {
        var array = [Post]()
        array.append(Post(author: "Джерри", description: "Мы с томом очень весело проводим время", image: "Джерри с Томом", likes: 20, views: 24))
        array.append(Post(author: "Утёнок", description: "Улетаю отдохнуть, друзья. Скоро вернусь!", image: "Утёнок", likes: 230, views: 470))
        array.append(Post(author: "Кошечка", description: "Скучаю...Не сходить ли нам куда- нибудь развлечься, друзья? ", image: "Кошечка", likes: 167, views: 209))
        array.append(Post(author: "Пёсель", description: "Провожу познавательную беседу с моим сыном как гонять кошек))Присоединяйся, Том!", image: "Песель", likes: 120, views: 130))
        return array
    }
    
}
