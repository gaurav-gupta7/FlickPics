//
//  PhotoSearchViewController.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 19/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import UIKit

class PhotoSearchViewController: UIViewController {

//    MARK: - Properties
    
    @IBOutlet weak var labelNoResults: UILabel!
    @IBOutlet weak var buttonLoadNextPage: UIButton!
    @IBOutlet weak var activityIndicatorViewFooter: UIActivityIndicatorView!
    @IBOutlet weak var viewIntroduction: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var viewModel: PhotoSearchViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            setupViewModel(with: viewModel)
        }
    }
    
//    MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
    }
    
    private func customizeUI(){
        buttonLoadNextPage.layer.cornerRadius = 13
    }
    
//    MARK: - Helper Methods
    
    private func updateView(for viewState: PhotoSearchViewState) {
        viewIntroduction.isHidden = true
        activityIndicatorView.stopAnimating()
        labelNoResults.isHidden = true
        
        switch viewState {
        case .introduction:
            viewIntroduction.isHidden = false
            showFooterButton(false)
            showFooterLoader(false)
        case .fetchingPhotos:
            activityIndicatorView.startAnimating()
            showFooterButton(false)
            showFooterLoader(false)
        case .fetchingNextPage:
            showFooterButton(false)
            showFooterLoader(true)
        case .fetchingNextPageFailed:
            showFooterLoader(false)
            showFooterButton(true)
        case .datafetched:
            showFooterButton(false)
            showFooterLoader(false)
            labelNoResults.isHidden = viewModel?.numberOfCells ?? 0 != 0
        }
    }
    
    private func handleError(for error: PhotoSearchError) {
        let title = "Unable to Fetch Photos"
        var message: String?
        switch error {
        case .failedRequest(let error):
            message = viewModel?.messasge(for: error)
        case .invalidResponse:
            message = "Something went wrong, please try again after sometime."
        case .unknown(let errorMessage):
            message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func didInsertIndexPaths(for indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
    
    private func didDeleteIndexPaths(for indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: indexPaths)
        }, completion: nil)
    }
    
//    MARK: -
    
    private func setupViewModel(with viewModel : PhotoSearchViewModel) {
        viewModel.didFailToFetchPhotos = {[weak self] (error) in
            DispatchQueue.main.async {
                self?.handleError(for: error)
            }
        }
        viewModel.didUpdateViewState = {[weak self] (state) in
            DispatchQueue.main.async {
                self?.updateView(for: state)
            }
        }
        viewModel.didAddPhotos = {[weak self] (indexPaths) in
            DispatchQueue.main.async {
                self?.didInsertIndexPaths(for: indexPaths)
            }
        }
        viewModel.didDeletePhotos = {[weak self] (indexPaths) in
            DispatchQueue.main.async {
                self?.didDeleteIndexPaths(for: indexPaths)
            }
        }
    }
    
    private func showFooterLoader(_ show: Bool) {
        show ? activityIndicatorViewFooter.startAnimating(): activityIndicatorViewFooter.stopAnimating()
        manageCollectionView(forFooterShown: show)
    }
    
    private func showFooterButton(_ show: Bool) {
        buttonLoadNextPage.isHidden =  !show
        manageCollectionView(forFooterShown: show)
    }
    
    private func manageCollectionView(forFooterShown shown: Bool) -> Void {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: (shown ?50:0), right: 0)
    }
    
    private func loadNextPage() {
        guard let viewModel = viewModel else {return}
        viewModel.fetchNextPage()
    }
    
//    MARK: - Actions
    
    @IBAction func didTapLoadNextPageButton(_ sender: UIButton) {
        loadNextPage()
    }
}

extension PhotoSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfCells ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.cellReuseIdentifier, for: indexPath) as? PhotoCollectionCell else {
            fatalError("Unexpected Collection View Cell")
        }
        if let photoViewModel = viewModel?.photoViewModel(for: indexPath.item) {
            cell.configure(with: photoViewModel)
        }
        return cell
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.cellSize ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        if indexPath.item == viewModel.numberOfCells - 3 {
            loadNextPage()
        }
    }
}

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = viewModel?.searchText
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        searchBar.text = text
        viewModel?.searchText = text
        searchBar.resignFirstResponder()
    }
}
