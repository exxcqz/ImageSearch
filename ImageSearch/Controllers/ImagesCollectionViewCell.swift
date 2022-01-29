//
//  ImagesCollectionViewCell.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 28.01.2022.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(imageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImagesCell(imageInfo: ImageInfo) {

        if let url = imageInfo.urls.raw {
            NetworkRequest.shared.requestData(urlString: url) { result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self.imageView.image = image
                case .failure(let error):
                    self.imageView.image = nil
                    print("Not found image cell: \(error.localizedDescription)")
                }
            }
        } else {
            imageView.image = nil
        }

    }
}

//MARK: - SetConstraints

extension ImagesCollectionViewCell {

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
