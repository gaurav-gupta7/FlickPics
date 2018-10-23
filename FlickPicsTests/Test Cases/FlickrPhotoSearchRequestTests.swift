//
//  FlickrPhotoSearchRequestTests.swift
//  FlickPicsTests
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import XCTest
@testable import FlickPics

class FlickrPhotoSearchRequestTests: XCTestCase {

    var request: FlickrPhotoSearchRequest!
    
    override func setUp() {
        super.setUp()
        
        request = FlickrPhotoSearchRequest(page: 1, text: "Cars")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testUrl() {
        XCTAssertEqual(request.url.absoluteString, "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&page=1&format=json&nojsoncallback=1&text=Cars&per_page=20")
    }

    

}
