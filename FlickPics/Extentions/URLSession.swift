//
//  URLSession.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 23/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

extension URLSession {
    func cancelAllTasks(completionHandler: @escaping () -> Void) -> Void {
        getAllTasks(completionHandler: { tasks in
            for task in tasks {
                task.cancel()
            }
            completionHandler()
        })
    }
}
