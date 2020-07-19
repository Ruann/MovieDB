//
//  ViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar[keyPath: \.searchTextField].font = UIFont(name: "OpenSans-regular", size: 15.0)
            searchBar[keyPath: \.searchTextField].textColor = .white
        }
    }
    
    @IBOutlet private weak var movieCollection: UICollectionView! {
        didSet {
            movieCollection.layer.roundCorners(cornerMasks: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 15)
        }
    }
    
    private var movieCategories: [MovieCategory] = MovieCategory.allCategories
    
    private var searchTerm: String? {
        didSet {
            if searchTerm != nil {
                movieCategories = [.search]
            } else {
                movieCategories = MovieCategory.allCategories
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollection.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCell")

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else {
            return UICollectionViewCell()
        }
        
        if let searchTerm = searchTerm {
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 290)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

extension HomeViewController: MovieListCellDelegate {
    func didSelect(movieTile: MovieTile, movieListCell: MovieListCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        movieDetailViewController.load(movieTile)
        
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text
        movieCollection.reloadData()
    }
}
