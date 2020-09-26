//
//  MovieExtension.swift
//  MoviesLib
//
//  Created by Valmir Junior on 24/09/20.
//

import Foundation

extension Movie {
    var ratingFormatted: String {
        if (rating ) > 5 {
            return "⭐️ \(rating )/10"
        } else {
            return "💩 \(rating )/10"
        }
    }
}
