//
//  Movie.swift
//  flix
//
//  Created by Jiaqi He on 2/28/18.
//  Copyright © 2018 Jiaqi He. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var posterUrl: URL?
    var posterPath: String
    var overview: String
    var releaseDate: String
    var backdropPath: String
    var backdropUrl: URL?
    var id: Int
    let baseURL = "https://image.tmdb.org/t/p/w500"
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        posterPath = dictionary["poster_path"] as! String
        overview = dictionary["overview"] as! String
        posterUrl = URL(string: baseURL + posterPath)!
        releaseDate = dictionary["release_date"] as! String
        backdropPath = dictionary["backdrop_path"] as! String
        backdropUrl = URL(string: baseURL + backdropPath)!
        id = dictionary["id"] as! Int
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
