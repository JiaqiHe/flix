//
//  DetailViewController.swift
//  flix
//
//  Created by Jiaqi He on 2/5/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import UIKit
enum MovieKeys {
    static let title = "title"
    static let backdropPath = "backdrop_path"
    static let posterPathString = "poster_path"
}


class DetailViewController: UIViewController {
    // declare elements
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBAction func trailerModal(_ sender: UIButton) {
        performSegue(withIdentifier: "trailerSegue", sender: nil)
    }
    
//    var movie: [String : Any]?
    var movie: Movie?
    var videos: [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let movie = movie {
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate as? String
            overviewLabel.text = movie.overview
            let backdropURL = movie.backdropUrl!
            backDropImageView.af_setImage(withURL: backdropURL)
            let posterURL = movie.posterUrl
            posterImageView.af_setImage(withURL: posterURL!)
            fetchvideo()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TrailerViewController
        let key = self.videos.first!["key"] as! String
        let baseURL = "https://www.youtube.com/watch?v="
        let videoURL = baseURL + key
        destinationViewController.url = videoURL
    }

    func fetchvideo() {
        let first_half = "https://api.themoviedb.org/3/movie/"
        let last_half = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let id = movie?.id as! Int
        let movie_id = String(id)
        let url = URL(string: first_half + movie_id + last_half)!
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
                self.videos = dataDictionary["results"] as! [[String: Any]]
//                self.tableView.reloadData()
//                self.refreshControl.endRefreshing()
//                self.showAnimatedProgressHUD(self.activityIndicator)
                //                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
