//
//  Array.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 22/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import Foundation

extension Array where Iterator.Element == Int {
    func indexPaths(forSection section:Int) -> Array<IndexPath> {
        return self.map{IndexPath(item: $0, section: section)}
    }
}
