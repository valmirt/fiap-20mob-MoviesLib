//
//  MovieExtension.swift
//  MoviesLib
//
//  Created by Valmir Junior on 24/09/20.
//

import UIKit

extension Movie {
    var ratingFormatted: String {
        if (rating ) > 5 {
            return "⭐️ \(rating )/10"
        } else {
            return "💩 \(rating )/10"
        }
    }
    
    var posterImage: UIImage? {
        if let data = image {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    var categoriesFormatted: String? {
        return (categories as? Set<Category>)?
            .compactMap({ $0.name })
            .sorted()
            .joined(separator: " | ")
    }
}
