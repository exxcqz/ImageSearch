//
//  ImagesCollectionViewCell.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 28.01.2022.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var task: URLSessionDataTask!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(imageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImagesCell(imageInfo: ImageInfo) {
        imageView.image = nil

        if let task = task {
            task.cancel()
        }

        guard let url = URL(string: imageInfo.urls.small) else { return }
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        task.resume()
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
