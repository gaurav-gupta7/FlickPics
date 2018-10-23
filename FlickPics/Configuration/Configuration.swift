//
//  Configuration.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 19/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

enum FlickrService {
    static let apiKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    static let baseUrl = URL(string: "https://api.flickr.com/services/rest/")!
}

enum FlickrServiceMethod {
    static let photoSearch = "flickr.photos.search"
}

enum FlickrImageSize {
    static let smallSquare_75 = "s"
    static let largeSquare_150 = "q"
    static let thumbnail_100 = "t"
    static let small_240 = "m"
    static let small_320 = "n"
    static let medium_500 = "-"
    static let medium_640 = "z"
    static let medium_800 = "c"
    static let large_1024 = "b"
    static let large_1600 = "h"
    static let large_2048 = "k"
    static let originalImage = "o"
}
