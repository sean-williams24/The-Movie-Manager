//
//  MovieDetailViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    
    // True if movie is on the watchlist, false if not
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        imageView?.image = UIImage(named: "PosterPlaceholder")

        TMDBClient.downloadPosterImage(posterPath: movie.posterPath ?? "") { (data, error) in
            guard let data = data else { return }
                let downloadedImage = UIImage(data: data)
                    self.imageView.image = downloadedImage
            }
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
        
    }
    
    // By tapping the button, we change whether or not movie os on watchlist (!isWatchlist)
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markWatchlist(movieID: movie.id, watchlist: !isWatchlist, completion: handleWatchlistResponse(success:error:))
    }
    
        
    func handleWatchlistResponse(success: Bool, error: Error?) {
        if success {
            if isWatchlist {
                // Set watchlist to every movie thats already in the watchlist excluding the one we deleted
                MovieModel.watchlist = MovieModel.watchlist.filter() { $0 != self.movie }
            } else {
                // if its not on watchlist, that means it was successfully added so append to watchlist in movie model
                MovieModel.watchlist.append(movie)
            }
            
            toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markFavorite(movieID: movie.id, favorite: !isFavorite, completion: handleFavoriteResponse(success:error:))
    }
    
    func handleFavoriteResponse(success: Bool, error: Error?) {
        if success {
            if isFavorite {
                MovieModel.favorites = MovieModel.favorites.filter() { $0 != self.movie }
            } else {
                MovieModel.favorites.append(movie)
            }
            
            toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        }
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    
}
