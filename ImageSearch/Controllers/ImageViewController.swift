//
//  ImageViewController.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 30.01.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        setConstraints()
    }
    
    func setImage(imageInfo: ImageInfo) {
        activityIndicator.startAnimating()
        let url = imageInfo.urls.regular
        NetworkDataFetch.shared.fetchImage(urlImage: url) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            let width = self.view.bounds.width
            let scale = width / CGFloat(imageInfo.width)
            self.imageView.heightAnchor.constraint(
                equalToConstant: CGFloat(imageInfo.height) * scale
            ).isActive = true
        }
    }
}

// MARK: - SetConstraints

extension ImageViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0)
        ])
    }
}
