//
//  DetailViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 22/09/20.
//

import UIKit
import AVKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var movie: Movie!
    var moviePlayer: AVPlayer?
    var moviePlayerController: AVPlayerViewController?
    var trailer: String = ""
    
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
        setupTrailer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegisterMovie" {
            if let detail = segue.destination as? FormViewController {
                detail.movie = movie
            }
        }
    }
    
    // MARK: - Methods
    private func setupTrailer() {
        if let title = movie.title {
            loadTrailer(with: title)
        }
    }
    
    private func loadTrailer(with title: String) {
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let itunesPath = "https://itunes.apple.com/search?media=movie&entity=movie&term=\(encodedTitle)"
        if let url = URL(string: itunesPath) {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let apiResult = try! JSONDecoder().decode(ItunesResult.self, from: data!)
                self.trailer = apiResult.results.first?.previewUrl ?? ""
                self.prepareVideo()
            }.resume()
        }
    }
    
    private func prepareVideo() {
        guard let url = URL(string: trailer) else { return }
        moviePlayer = AVPlayer(url: url)
        DispatchQueue.main.async {
            self.moviePlayerController = AVPlayerViewController()
            self.moviePlayerController?.player = self.moviePlayer
        }
    }
    
    private func setupView() {
        labelTitle.text = movie.title
        labelTime.text = movie.duration
        labelCategories.text = movie.categoriesFormatted
        labelRating.text = movie.ratingFormatted
        tvSinopse.text = movie.summary
        ivPoster.image = movie.posterImage
    }
    
    // MARK: - IBActions
    @IBAction func playTrailer(_ sender: UIButton) {
        guard let moviePlayerController = moviePlayerController else { return }
        present(moviePlayerController, animated: true) {
            self.moviePlayer?.play()
        }
    }
}
