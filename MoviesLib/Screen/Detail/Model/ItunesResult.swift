//
//  ItunesResult.swift
//  MoviesLib
//
//  Created by Valmir Junior on 29/09/20.
//

import Foundation

struct ItunesResult: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    let previewUrl: String
}
