//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 24/09/20.
//

import UIKit
import CoreData

final class MoviesTableViewController: UITableViewController {
    // MARK: - Properties
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Without movies registered"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    lazy var fetchedResultsContrtoller: NSFetchedResultsController<Movie> = {
        let fetchedRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsContrtoller = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsContrtoller.delegate = self
        
        return fetchedResultsContrtoller
    }()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let detail = segue.destination as? DetailViewController,
               let index = tableView.indexPathForSelectedRow {
                let movie = fetchedResultsContrtoller.object(at: index)
                detail.movie = movie
            }
        }
    }
    
    // MARK: - Methods
    private func loadMovies() {
        try? fetchedResultsContrtoller.performFetch()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsContrtoller.fetchedObjects?.count ?? 0
        tableView.backgroundView = count > 0 ? nil : label
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = fetchedResultsContrtoller.object(at: indexPath)
        cell.fill(data: movie)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = fetchedResultsContrtoller.object(at: indexPath)
            context?.delete(movie)
            try? context?.save()
        }
    }
}

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


