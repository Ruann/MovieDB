//
//  ViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var movieCollection: UICollectionView!
    private var movieCategories = MovieCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollection.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
        let movieProvider = MovieCategoryProvider(movieCategory: movieCategories[indexPath.row])
        movieListCell.prepare(movieCategoryProvider: movieProvider)
        movieListCell.delegate = self

        return movieListCell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 350)
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
