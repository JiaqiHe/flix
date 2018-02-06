//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Jiaqi He on 1/31/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBlock: UISearchBar!
    
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // search bar
        searchBlock.delegate = self as! UISearchBarDelegate
        
        // HUD
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        
        // table cell set
        self.tableView.rowHeight = 160
        
        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        fetchMovies()
    }

    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            fetchMovies()
        }
        else {
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
                    self.movies = []
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let allMovies = dataDictionary["results"] as! [[String: Any]]
                    //==================search==================
                    for movie in allMovies {
                        let title = movie["title"] as! String
                        if (title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) {
                            self.movies.append(movie)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
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
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.showAnimatedProgressHUD(self.activityIndicator)
//                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterpass = movie["poster_path"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURL + posterpass)!
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.af_setImage(withURL: posterURL)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
    
    // HUD functions
    @IBAction func showAnimatedSuccessHUD(_ sender: AnyObject) {
        HUD.flash(.success, delay: 2.0)
    }
    
    @IBAction func showAnimatedErrorHUD(_ sender: AnyObject) {
        HUD.show(.error)
        HUD.hide(afterDelay: 2.0)
    }
    
    @IBAction func showAnimatedProgressHUD(_ sender: AnyObject) {
        HUD.show(.progress)
        
        // Now some long running task starts...
        delay(0.8) {
            // ...and once it finishes we flash the HUD for a second.
            HUD.flash(.success, delay: 0.2)
        }
    }
    
    @IBAction func showCustomProgressHUD(_ sender: AnyObject) {
        HUD.flash(.rotatingImage(UIImage(named: "progress")), delay: 2.0)
    }
    
    @IBAction func showAnimatedStatusProgressHUD(_ sender: AnyObject) {
        HUD.flash(.labeledProgress(title: "Title", subtitle: "Subtitle"), delay: 2.0)
    }
    
    @IBAction func showTextHUD(_ sender: AnyObject) {
        HUD.flash(.label("Requesting Licence…"), delay: 2.0) { _ in
            print("License Obtained.")
        }
    }
    
    /*
     
     Please note that the above demonstrates the "porcelain" interface - a more concise and clean way to work with the HUD.
     If you need more options and flexbility, feel free to use the underlying "plumbing". E.g.:
     
     PKHUD.sharedHUD.show()
     PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Success!", subtitle: nil)
     PKHUD.sharedHUD.hide(afterDelay: 2.0)
     */
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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
