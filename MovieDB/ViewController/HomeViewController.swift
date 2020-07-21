//
//  ViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit
import Network

//MARK: - HomeViewController

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchHeaderLabel: UILabel! {
        didSet {
            searchHeaderLabel.text = AppStrings.Home.searchHeader
        }
    }
    
    @IBOutlet weak var headerSearchLabel: UILabel! {
        didSet {
            headerSearchLabel.addLineSpacing(headerSearchLabelLineSpacing)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.customize()
            searchBar.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet private weak var movieCollection: UICollectionView! {
        didSet {
            movieCollection.layer.roundCorners(cornerMasks: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: movieCollectionRadius)
            movieCollection.register(MovieListCell.nib, forCellWithReuseIdentifier: MovieListCell.identifier)
        }
    }
    
    @IBOutlet weak var movieListsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backToCategoriesButton: UIButton!
    @IBOutlet weak var failedToLoadMoviesLabel: UILabel!
    
    //MARK: - Properties
    
    private var movieCategories: [MovieCategory] = MovieCategory.allCategories
    private var monitor: NWPathMonitor?
    
    private var searchText: String? {
        didSet {
            if searchText != nil {
                movieCategories = [.search]
            } else {
                movieCategories = MovieCategory.allCategories
            }
        }
    }
    
    //MARK: - Constants
    
    let headerSearchLabelLineSpacing: CGFloat = 5.0
    let movieCollectionRadius: CGFloat = 15.0
    let movieListCellHeight: CGFloat = 290
    let movieCollectionInsets = UIEdgeInsets(top: 40.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    //MARK: - Life Cycle
    
    private var isConfigurationLoaded: Bool {
        Configuration.shared != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isConfigurationLoaded {
            NotificationCenter.default.addObserver(self, selector: #selector(onConfigurationLoaded), name: .configurationLoaded, object: nil)
        } else {
            movieListsActivityIndicator.stopAnimating()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLostInternetConnection), name: .lostInternetConnection, object: nil)
        
        startNetworkMonitor()
    }
    
    //MARK: - Private methods
    
    @objc private func onConfigurationLoaded(_ notification:Notification) {
        movieCollection.reloadData()
        searchBar.isUserInteractionEnabled = true
        movieListsActivityIndicator.stopAnimating()
    }
    
    @objc private func onLostInternetConnection(_ notification:Notification) {
        DispatchQueue.main.async() { [weak self] in
            self?.showNoNetworkAlert()
            self?.showErrorLabelIfNecessary()
        }
    }
    
    private func showErrorLabelIfNecessary() {
        guard !isConfigurationLoaded else { return }
        
        failedToLoadMoviesLabel.isHidden = false
        movieListsActivityIndicator.stopAnimating()
    }
    
    private func startNetworkMonitor() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.startNetworkMonitor()
    }
    
    //MARK: - Actions
    
    @IBAction func backToCategoriesButtonClicked(_ sender: Any) {
        searchText = nil
        movieCollection.reloadData()
        backToCategoriesButton.isHidden = true
        searchBar.text = nil
    }
}

//MARK: - CollectionView Delegates

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard isConfigurationLoaded else {
            return 0
        }
        
        return movieCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieListCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell else {
            return UICollectionViewCell()
        }
        
        if let searchTerm = searchText {
            let movieProvider = MovieCategoryProvider(searchText: searchTerm)
            movieListCell.prepare(movieCategoryProvider: movieProvider)
        } else {
            let movieProvider = MovieCategoryProvider(movieCategory: movieCategories[indexPath.row])
            movieListCell.prepare(movieCategoryProvider: movieProvider)
        }
        
        movieListCell.delegate = self

        return movieListCell
    }
}

//MARK: - CollectionView Layout Delegate

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: movieListCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return movieCollectionInsets
    }
}

//MARK: - Search Bar Delegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text
        backToCategoriesButton.isHidden = false
        movieCollection.reloadData()
    }
}

//MARK: - MovieListCell Delegate

extension HomeViewController: MovieListCellDelegate {
    func didSelect(movieTile: MovieTile, movieListCell: MovieListCell) {
        let viewController = loadFromMainBundle(viewControllerIdentifier: MovieDetailViewController.identifier)
        guard let movieDetailViewController = viewController as? MovieDetailViewController else { return }
        
        movieDetailViewController.load(movieTile)
        
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
