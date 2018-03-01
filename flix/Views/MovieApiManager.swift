//
//  MovieApiManager.swift
//  flix
//
//  Created by Jiaqi He on 2/28/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import PKHUD

class MovieApiManager {
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func nowPlayingMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseUrl + "now_playing?api_key=\(MovieApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]

                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
//        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            // This will run when the network request returns
//            if let error = error {
//                print(error.localizedDescription)
//                // network error alert
//                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
//                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                    // handle response here.
//
//                }
//                // add the OK action to the alert controller
//                alertController.addAction(OKAction)
//                self.present(alertController, animated: true) {
//                    // optional code for what happens after the alert controller has finished presenting
//                }
//            } else if let data = data {
//                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
//                self.movies = Movie.movies(dictionaries: movieDictionaries)
//
//                self.tableView.reloadData()
//                self.refreshControl.endRefreshing()
//                self.showAnimatedProgressHUD(self.activityIndicator)
//                //                self.activityIndicator.stopAnimating()
//            }
//        }
//        task.resume()
    }
    
    
}
