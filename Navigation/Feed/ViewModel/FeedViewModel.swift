//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Олеся on 05.11.2022.
//

import Foundation

final class FeedViewModel {
    
    let model: FeedModelProtocol
    let bruteForce = BruteForce()
    
    enum State {
        case viewIsReady
        case buttonTapped
    }
    var stateChanged: ((State)-> Void)?
    var word: String?
    var result : Bool?
    
    init(model: FeedModelProtocol){
        self.model = model
    }
    
    private(set) var state: State = .viewIsReady {
        didSet {
            stateChanged?(state)
        }
    }
    
    func changeState(action: State) {
        switch action {
            case .viewIsReady:
                ()
            case .buttonTapped:
           guard let word = word else {return}
                result = model.check(word: word)
        }
    }
}
