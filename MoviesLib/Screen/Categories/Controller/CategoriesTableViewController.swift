//
//  CategoriesTableViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 26/09/20.
//

import UIKit
import CoreData

protocol CategoriesDelegate: class {
    func setSelection(categories: Set<Category>)
}

final class CategoriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    weak var delegate: CategoriesDelegate?
    private var selectedCategories: Set<Category> = [] {
        didSet { delegate?.setSelection(categories: selectedCategories) }
    }
    private var categories: [Category] = []
    // MARK: - IBOutlets
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Methods
    private func loadCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            categories = try context!.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // MARK: - IBActions
    @IBAction func add(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
}

