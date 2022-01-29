//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by Nikita Gavrikov on 28.01.2022.
//

import UIKit

class SearchViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    private var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var imagesData = [ImageInfo]()
    private var query = ""
    private var currentPage = 1
    private var width = UIScreen.main.bounds.size.width / 375

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setDelegate()
        setConstraints()
        setNavigationBar()
        setupSearchController()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imagesCollectionView)
    }

    private func setDelegate() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        searchController.searchBar.delegate = self
    }

    private func setNavigationBar() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func fetchImages(query: String, page: Int) {

        NetworkDataFetch.shared.fetchImages(query: query, page: page) { searchResult, error in
            if error == nil {
                guard let searchResult = searchResult else { return }
                self.imagesData.append(contentsOf: searchResult.results)
                self.imagesCollectionView.reloadData()
            } else {
                print(error)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagesCollectionViewCell
        let imageInfo = imagesData[indexPath.row]
        cell.configureImagesCell(imageInfo: imageInfo)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imagesData.count - 1 {
            currentPage += 1
            print(currentPage)
            fetchImages(query: query, page: currentPage)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: 83 * width,
            height: 83 * width
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        guard let query = query else { return }
        if query != "" {
            self.imagesData.removeAll()
            self.query = query
            self.currentPage = 1
            self.fetchImages(query: query, page: currentPage)
        }
    }
}

//MARK: - SetConstraints

extension SearchViewController {

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            imagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
