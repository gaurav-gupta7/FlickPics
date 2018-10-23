//
//  ImageSearchViewModel.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 19/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import UIKit

enum PhotoSearchViewState {
    case introduction
    case fetchingPhotos
    case fetchingNextPage
    case fetchingNextPageFailed
    case datafetched
}

enum PhotoSearchError: Error {
    case failedRequest(Error)
    case invalidResponse
    case unknown(String)
}

class PhotoSearchViewModel {
    
//    MARK: - Type Aliases
    
    typealias DidFailToFetchPhotosHandler = (PhotoSearchError) -> Void
    typealias DidUpdateViewStateHandler = (PhotoSearchViewState) -> Void
    typealias DidAddPhotosCompletion = ([IndexPath]) -> Void
    typealias DidDeletePhotosCompletion = ([IndexPath]) -> Void
    
//    MARK: - Properties
    
    private let session: URLSession
    
    private var photosApiResponse: FlickrSearchResponse?
    private var photos = [FlickrPhotoResponse]()
    private var apiInProgress = false
    private var viewState: PhotoSearchViewState = .introduction {
        didSet {
            didUpdateViewState?(viewState)
        }
    }
    private var isLastPage: Bool {
        guard let page = photosApiResponse?.photos?.page, let totalPages = photosApiResponse?.photos?.pages, page < totalPages else {return true}
        return false
    }
    
//    MARK: -
    
    var didFailToFetchPhotos: DidFailToFetchPhotosHandler?
    var didUpdateViewState: DidUpdateViewStateHandler?
    var didAddPhotos: DidAddPhotosCompletion?
    var didDeletePhotos: DidDeletePhotosCompletion?

//    MARK: -
    
    var searchText: String? {
        didSet {
            clearPhotos()
            getPhotos()
        }
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    
    var numberOfCells: Int {
        return photos.count
    }
    
    var cellSize: CGSize {
        let width = (min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 2)/3
        return CGSize(width: width, height: width)
    }
    
//    MARK: - Initializer
    init(session: URLSession) {
        self.session = session
    }
    
//    MARK: - Healper Methods
    
    func messasge(for error:Error) -> String{
        let error = error as NSError
        return error.localizedDescription
    }
    
    func photoViewModel(for index: Int) -> PhotoViewModel {
        return PhotoViewModel(photoData: photos[index], cache: imageCache)
    }
    
    func fetchNextPage() {
        guard let text = searchText, let page = photosApiResponse?.photos?.page else {
            return
        }
        guard !apiInProgress else {return}
        guard !isLastPage else {return}
        viewState = .fetchingNextPage
        let request = FlickrPhotoSearchRequest(page: page + 1, text: text)
        fetchPhotos(with: request)
    }
    
    func clearPhotos() {
        guard photos.count > 0 else {return}
        let indexPaths = Array(0...(photos.count - 1)).indexPaths(forSection: 0)
        photos.removeAll()
        didDeletePhotos?(indexPaths)
        viewState = .introduction
    }
    
//    MARK: -
    
    private func getPhotos() {
        guard let searchText = searchText, !searchText.isEmpty else {return}
        viewState = .fetchingPhotos
        session.cancelAllTasks {
            let request = FlickrPhotoSearchRequest(page: 1, text: searchText)
            self.fetchPhotos(with: request)
        }
    }
    
    private func fetchPhotos(with request: FlickrPhotoSearchRequest) {
        apiInProgress = true
        session.dataTask(with: request.url) {[weak self] (data, response, error) in
            self?.apiInProgress = false
            if let error = error as NSError?{
                guard !error.isCancelled else {return}
                self?.viewState = (self?.viewState == .fetchingPhotos) ? .introduction : .fetchingNextPageFailed
                self?.didFailToFetchPhotos?(.failedRequest(error))
            } else if let data = data {
                self?.configureApiResponse(data: data)
            }
        }.resume()
    }
    
    private func configureApiResponse(data: Data){
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(FlickrSearchResponse.self, from: data)
            if response.stat == "ok"{
                if let newPhotos = response.photos?.photo, newPhotos.count > 0 {
                    let firstIndex = photos.count
                    let lastIndex = firstIndex + newPhotos.count - 1
                    self.photos.append(contentsOf: newPhotos)
                    let indexPaths = Array(firstIndex...lastIndex).indexPaths(forSection: 0)
                    self.didAddPhotos?(indexPaths)
                }
            } else if let errorMessgae = response.message {
                didFailToFetchPhotos?(.unknown(errorMessgae))
                photosApiResponse = nil
                self.viewState = (viewState == .fetchingPhotos) ? .introduction : .fetchingNextPageFailed
                didFailToFetchPhotos?(.invalidResponse)
                return
            }
            
            photosApiResponse = response
            self.viewState = .datafetched
        } catch  {
            self.viewState = (viewState == .fetchingPhotos) ? .introduction : .fetchingNextPageFailed
            didFailToFetchPhotos?(.invalidResponse)
        }
    }
}
