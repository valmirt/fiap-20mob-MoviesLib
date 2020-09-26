//
//  MovieTableViewCell.swift
//  MoviesLib
//
//  Created by Valmir Junior on 24/09/20.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    

    //MARK: - Methods
    func fill(data movie: Movie) {
        labelTitle.text = movie.title
        labelCategories.text = movie.categoriesFormatted
        labelRating.text = movie.ratingFormatted
        ivPoster.image = movie.posterImage
    }
}
