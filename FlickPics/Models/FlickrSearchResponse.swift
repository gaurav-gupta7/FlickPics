//
//  FlickrSearchResponse.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 21/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation


struct FlickrSearchResponse: Codable {
    let stat: String
    let photos: FlickrPhotosResponse?
    let message: String?
}
struct FlickrPhotosResponse: Codable {
    let photo: [FlickrPhotoResponse]
    let page: Int
    let pages: Int
}
struct FlickrPhotoResponse: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
}
