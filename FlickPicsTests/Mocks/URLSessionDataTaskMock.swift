//
//  URLSessionDataTaskMock.swift
//  FlickPicsTests
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
