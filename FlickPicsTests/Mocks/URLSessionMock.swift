//
//  URLSessionMock.swift
//  FlickPicsTests
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    
    var data: Data?
    var error: Error?
    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
    
    override func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
        completionHandler([URLSessionTask]())
    }
}
