//
//  Movie.swift
//  MoviesLib
//
//  Created by Valmir Junior on 24/09/20.
//

import Foundation

struct Movie : Decodable {
    let title: String?
    let categories: String?
    let duration: String?
    let rating: Double?
    let summary: String?
    let image: String?
}
