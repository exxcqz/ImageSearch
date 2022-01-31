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
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var imagesData = [ImageInfo]()
    private var query = ""
    private var currentPage = 1
    private var totalPage = 1
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

    private func fetchData(query: String, page: Int) {
        for page in page...page + 10 {
            NetworkDataFetch.shared.fetchSearchData(query: query, page: page) { searchResult, error in
                if error == nil {
                    guard let searchResult = searchResult else { return }
                    self.imagesData.append(contentsOf: searchResult.results)
                    self.totalPage = searchResult.totalPages
                    if self.currentPage == self.totalPage { return }
                    self.currentPage += 1
                    DispatchQueue.main.async {
                        self.imagesCollectionView.reloadData()
                    }
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("будет отображаться - \(indexPath.row), всего в массиве - \(imagesData.count)")
        if indexPath.row == imagesData.count - 15 && currentPage < totalPage {
            fetchData(query: query, page: currentPage)
            //            var indexPaths: [IndexPath] = []
            //            for i in indexPath.row...indexPath.row + 30 {
            //                indexPaths.append(IndexPath(row: i, section: 0))
            //            }
            //            DispatchQueue.main.async {
            //                self.imagesCollectionView.reloadItems(at: indexPaths)
            //            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageViewController = ImageViewController()
        imageViewController.title = query
        let imageInfo = imagesData[indexPath.row]
        imageViewController.setImage(imageInfo: imageInfo)
        navigationController?.pushViewController(imageViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        guard let query = query else { return }
        if query != "" {
            self.imagesData.removeAll()
            self.imagesCollectionView.reloadData()
            CacheManager.cache.removeAllObjects()
            self.query = query
            self.currentPage = 1
            self.fetchData(query: query, page: currentPage)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.imagesData.removeAll()
        self.imagesCollectionView.reloadData()
        CacheManager.cache.removeAllObjects()
    }
}

// MARK: - SetConstraints

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
