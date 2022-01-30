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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        setConstraints()
    }

    func setImage(imageInfo: ImageInfo) {
        let url = imageInfo.urls.full
        NetworkRequest.shared.requestDataString(urlString: url) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.imageView.image = image
                let width = self.view.bounds.width
                let scale = width / CGFloat(imageInfo.width)
                self.imageView.heightAnchor.constraint(equalToConstant: CGFloat(imageInfo.height) * scale).isActive = true
            case .failure(let error):
                self.imageView.image = nil
                print("Not found image cell: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - SetConstraints

extension ImageViewController {

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10)
        ])
    }
}
