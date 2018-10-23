//
//  PhotoViewModel.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 21/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import UIKit

class PhotoViewModel {
    
//    MARK: Type Aliases
    
    typealias DidFetchPhotoCompletion = (UIImage?, String?) -> Void
    
//    MARK: Properties
    
    private let photoData: FlickrPhotoResponse
    private let cache: NSCache<NSString, UIImage>
    var url: URL? {
        guard let url = URL(string: "http://farm\(photoData.farm).static.flickr.com/\(photoData.server)/\(photoData.id)_\(photoData.secret)_\(FlickrImageSize.small_320).jpg") else {
            return nil
        }
        return url
    }

//    MARK: -
    
    var didFetchPhoto: DidFetchPhotoCompletion?
    
//    MARK: - Initializer
    
    init(photoData: FlickrPhotoResponse, cache: NSCache<NSString, UIImage>) {
        self.photoData = photoData
        self.cache = cache
    }
    
//    MARK: - Helper Methods
    
    func fetchPhoto() {
        guard let url = url else {return}
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            self.didFetchPhoto?(image, nil)
            return
        }
        URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            if let error = error as NSError?{
                guard !error.isCancelled else {return}
                self?.didFetchPhoto?(nil, error.localizedDescription)
            } else if let data = data, let image = UIImage(data: data) {
                self?.cache.setObject(image, forKey: url.absoluteString as NSString)
                self?.didFetchPhoto?(image, nil)
            }
            }.resume()
    }
}
