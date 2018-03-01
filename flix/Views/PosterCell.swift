//
//  PosterCell.swift
//  flix
//
//  Created by Jiaqi He on 2/6/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    var movie: Movie? {
        didSet{
            posterImageView.af_setImage(withURL: (movie?.posterUrl)!)
        }
    }
    @IBOutlet weak var posterImageView: UIImageView!
    
}
