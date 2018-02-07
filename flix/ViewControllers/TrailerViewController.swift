//
//  TrailerViewController.swift
//  flix
//
//  Created by Jiaqi He on 2/6/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var trailerWebView: UIWebView!
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Convert the url String to a NSURL object.
        let requestURL = URL(string:url)!
        // Place the URL in a URL Request.
        let request = URLRequest(url: requestURL)
        // Load Request into WebView.
        trailerWebView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
