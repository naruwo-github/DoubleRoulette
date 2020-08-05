//
//  DoubleRouletteTests.swift
//  DoubleRouletteTests
//
//  Created by Narumi Nogawa on 2020/08/05.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import XCTest

class DoubleRouletteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("テスト実行前に呼ばれる")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        print("テスト実行後に呼ばれる")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let num = 10
        XCTAssert(num <= 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            print("measureの中")
        }
    }

}
