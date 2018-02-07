//
//  SuperheroViewController.swift
//  flix
//
//  Created by Jiaqi He on 2/6/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    var movies: [[String: Any]] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal/cellsPerLine
        layout.itemSize = CGSize(width: width, height: width*3/2)
        
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovies() {
        //        self.activityIndicator.startAnimating()
        //        showAnimatedProgressHUD(activityIndicator)
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                // network error alert
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                    
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.collectionView.reloadData()
//                self.refreshControl.endRefreshing()
//                self.showAnimatedProgressHUD(self.activityIndicator)
                //                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.item]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
}
