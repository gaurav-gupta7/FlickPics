//
//  Error.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

extension NSError{
    var isCancelled: Bool {
        guard domain == NSURLErrorDomain else {
            return false
        }
        return code == -999
    }
}
