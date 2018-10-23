//
//  FlickrSearchResponseTests.swift
//  FlickPicsTests
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import XCTest
@testable import FlickPics

class FlickrSearchResponseTests: XCTestCase {

    let decoder = JSONDecoder()
    
    var response: FlickrSearchResponse!
    override func setUp() {
        super.setUp()
        let data = loadStub(name: "FlickrResponse", extension: "json")
        response = try! decoder.decode(FlickrSearchResponse.self, from: data)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testStat() {
        XCTAssertEqual(response.stat, "ok")
    }
    
    func testPage() {
        XCTAssertEqual(response.photos?.page, 1)
    }
    func testPages() {
        XCTAssertEqual(response.photos?.pages, 26763)
    }
    func testId() {
        XCTAssertEqual(response.photos?.photo[0].id, "31642905188")
    }
    func testSecret() {
        XCTAssertEqual(response.photos?.photo[0].secret, "8050459aa1")
    }
    func testServer() {
        XCTAssertEqual(response.photos?.photo[0].server, "1937")
    }
    func testFarm() {
        XCTAssertEqual(response.photos?.photo[0].farm, 2)
    }
}
