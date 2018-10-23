//
//  PhotoSearchViewModelTests.swift
//  FlickPicsTests
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import XCTest
@testable import FlickPics

class PhotoSearchViewModelTests: XCTestCase {

    let session = URLSessionMock()
    var viewModel: PhotoSearchViewModel!
    
    override func setUp() {
        super.setUp()
        let data = loadStub(name: "FlickrResponse", extension: "json")
        session.data = data
        viewModel = PhotoSearchViewModel(session: session)
        viewModel.searchText = "Cars"
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfCells() {
        XCTAssertEqual(viewModel.numberOfCells, 14)
    }
    
//    
//    internal func photoViewModel(for index: Int) -> PhotoViewModel
//    
//    internal func fetchNextPage()
//
    func testSearchTest(){
        XCTAssertEqual(viewModel.searchText, "Cars")
    }
    
    func testDidInsert(){
        viewModel.didAddPhotos = {(indePaths) in
            XCTAssertEqual(indePaths.count, 14)
        }
        viewModel.searchText = "Cars"
    }
    
    
    func testClearPhotos(){
        viewModel.didDeletePhotos = {(indePaths) in
            XCTAssertEqual(indePaths.count, 14)
        }
        viewModel.clearPhotos()
        XCTAssertEqual(viewModel.numberOfCells, 0)
    }
    
    func testPhotoViewModelForIndex(){
        let cache = NSCache<NSString, UIImage>()
        let data = FlickrPhotoResponse(id: "31642905188", secret: "8050459aa1", server: "1937", farm: 2)
        let compareViewModel = PhotoViewModel(photoData: data, cache: cache)
        
        let photoViewModel = viewModel.photoViewModel(for: 0)
        XCTAssertEqual(photoViewModel.url?.absoluteString, compareViewModel.url?.absoluteString)
    }
    
    func testFetchNextPage(){
        viewModel.fetchNextPage()
        XCTAssertEqual(viewModel.numberOfCells, 28)
    }
    
}
