//
//  CheckerServiceTests.swift
//  CheckerServiceTests
//
//  Created by Олеся on 19.05.2023.

import XCTest
import RealmSwift
@testable import Navigation

final class NavigationTests: XCTestCase {

    private var service: CheckerService!

    func test_SignUpSucceed() throws {
        // given
        service = CheckerService.shared
        // when
        service.signUp(login: TestData.login, password: TestData.password)

        let user = service.realm.objects(User.self).last
        let password = user?.password ?? ""
        let email = user?.email ?? ""

        // then
        XCTAssertEqual(email, TestData.login)
        XCTAssertEqual(password, TestData.password)
    }

    func test_SignUpWrongLoginFailure() throws {
        // given
        service = CheckerService.shared
        // when
        service.signUp(login: TestData.wrongLogin, password: TestData.password)

        let user = service.realm.objects(User.self).last
        let password = user?.password ?? ""
        let email = user?.email ?? ""

        // then
        XCTAssertNotEqual(email, TestData.login)
        XCTAssertEqual(password, TestData.password)
    }

    func test_SignUpWrongPasswordFailure() throws {
        // given
        service = CheckerService.shared
        // when
        service.signUp(login: TestData.login, password: TestData.wrongPassword)

        let user = service.realm.objects(User.self).last
        let password = user?.password ?? ""
        let email = user?.email ?? ""

        // then
        XCTAssertNotEqual(password, TestData.password)
        XCTAssertEqual(email, TestData.login)
    }
}

extension NavigationTests {
    private enum TestData {
        static let login: String = "a"
        static let password: String = "b"
        static let wrongLogin: String = "login"
        static let wrongPassword: String = "password"
    }
}
