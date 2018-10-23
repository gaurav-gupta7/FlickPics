//
//  FlickrPhotoSearchRequest.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 19/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

struct FlickrPhotoSearchRequest {
    let page: Int
    let text: String
    let perPage = 20
    var url: URL {
        return makeUrl()
    }
    
    private func makeUrl() -> URL {
        let a = [URLQueryItem(name: "method", value: FlickrServiceMethod.photoSearch),
                 URLQueryItem(name: "api_key", value: FlickrService.apiKey),
                 URLQueryItem(name: "page", value: String(page)),
                 URLQueryItem(name: "format", value: "json"),
                 URLQueryItem(name: "nojsoncallback", value: "1"),
                 URLQueryItem(name: "text", value: text),
                 URLQueryItem(name: "per_page", value: String(perPage)),]
        
        var components = URLComponents(url: FlickrService.baseUrl, resolvingAgainstBaseURL: false)!
        components.queryItems = a
        return components.url!
    }
}
