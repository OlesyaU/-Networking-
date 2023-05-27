//
//  FeedModelTests.swift
//  FeedModelTests

//  Created by Олеся on 22.05.2023.


import XCTest
import RealmSwift
@testable import Navigation

final class FeedModelTests: XCTestCase {
    var model: FeedModelProtocol?

    func test_CheckSucceed() throws {
        guard let model else { return}

        // given
        let word = "Password"

        // when
        let result = model.check(word: word)

        // then
        XCTAssertTrue(result)
    }
    
    func test_CheckFailure() throws {
        guard let model else { return}

        // given
        let word = "BlaBlaBla"

        // when
        let result = model.check(word: word)

        // then
        XCTAssertFalse(result)
    }
}


