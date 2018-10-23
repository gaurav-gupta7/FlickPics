//
//  PhotoCollectionCell.swift
//  FlickPics
//
//  Created by Gaurav Gupta on 21/10/18.
//  Copyright © 2018 Gaurav Gupta. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    private enum TemplateImage: String {
        case placeholder = "imagePlaceholder"
        case brokenImage = "imageBroken"
    }
    
    static var cellReuseIdentifier : String {
        return String(describing: self)
    }
    
//    MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    var viewModel: PhotoViewModel?
    
//    MARK: - Configuration
    
    func configure(with viewModel: PhotoViewModel) {
        setTemplateImage(.placeholder)
        self.viewModel = viewModel
        viewModel.didFetchPhoto = {[weak self] (image, errorMessage) in
            DispatchQueue.main.async {
                guard let image = image else{
                    self?.setTemplateImage(.brokenImage)
                    return
                }
                self?.setImage(image)
            }
        }
        viewModel.fetchPhoto()
    }
//    MARK: - Helper Methods
    
    private func setTemplateImage(_ imageName: TemplateImage) {
        imageView.contentMode = .center
        imageView.tintColor = UIColor.lightGray
        imageView.image = UIImage(imageLiteralResourceName:imageName.rawValue).withRenderingMode(.alwaysTemplate)
    }
    
    private func setImage(_ image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
}
