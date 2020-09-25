//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 24/09/20.
//

import UIKit

final class MoviesTableViewController: UITableViewController {
    // MARK: - Properties
    var movies: [Movie] = []
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let detail = segue.destination as? DetailViewController {
                detail.movie = movies[tableView.indexPathForSelectedRow?.row ?? 0]
            }
        }
    }
    
    // MARK: - Methods
    private func loadMovies() {
        guard let jsonURL = Bundle.main.url(forResource: "movies", withExtension: "json") else { return }
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            movies = try JSONDecoder().decode([Movie].self, from: jsonData)
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.fill(data: movies[indexPath.row])

        return cell
    }
}
