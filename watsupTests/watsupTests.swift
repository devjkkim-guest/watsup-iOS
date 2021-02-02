//
//  watsupTests.swift
//  watsupTests
//
//  Created by Jeongkyun Kim on 2021/01/20.
//

import XCTest
@testable import watsup

class watsupTests: XCTestCase {
    
    var authLoginViewController: AuthLoginViewController?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        authLoginViewController = AuthLoginViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        authLoginViewController = nil
    }

    func testLoginApiResponse() {
        let e = expectation(description: "login api")
        let body = PostAuthRequest(email: "abc@abc.com", password: "abcd")
        authLoginViewController?.requestLogin(body: body) { result in
            XCTAssertTrue(result != true)
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
