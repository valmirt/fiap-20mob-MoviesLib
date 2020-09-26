//
//  DetailViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 22/09/20.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var movie: Movie!
    
    // MARK: - IBOutlets
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var tvSinopse: UITextView!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        labelTitle.text = movie.title
        labelTime.text = movie.duration
//        labelCategories.text = movie.categories
        labelRating.text = movie.ratingFormatted
        tvSinopse.text = movie.summary
    }
    
    // MARK: - IBActions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegisterMovie" {
            if let detail = segue.destination as? FormViewController {
                detail.movie = movie
            }
        }
    }
    
}
