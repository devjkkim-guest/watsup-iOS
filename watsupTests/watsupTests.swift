//
//  watsupTests.swift
//  watsupTests
//
//  Created by Jeongkyun Kim on 2021/01/20.
//

import XCTest
@testable import watsup

class watsupTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJoinApiResponse() {
        let e = expectation(description: "join api")
        
        let deviceToken = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceToken.rawValue)
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let languageCode = Locale.preferredLanguages.first ?? "en_US"
        let userData = PostUsersRequest(email: "abc@abcdwefa.net",
                                        gmt_tz_offset: 0, password: "test123!",
                                        device_uuid: UUID().uuidString,
                                        device_token: deviceToken ?? "abc",
                                        os_type: OSType.iOS.rawValue,
                                        app_version: appVersion ?? "0",
                                        language_code: languageCode)
        API.shared.postUser(userData) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let data):
                XCTAssertTrue(data.errorCode == 409)
            }
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
