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
    
    private func showCategoryAlert(for category: Category? = nil) {
        let title = category == nil ? "Add" : "Update"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Category name"
            textField.text = category?.name
        }
        
        let okAction = UIAlertAction(title: title, style: .default) { (_) in
            if let text = alert.textFields?.first?.text {
                let category = category ?? Category(context: self.context!)
                category.name = text
                
                do {
                    try self.context?.save()
                    self.loadCategories()
                } catch {
                    print(error)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func add(_ sender: UIBarButtonItem) {
        showCategoryAlert()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let category = categories[indexPath.row]
        
        if selectedCategories.contains(category) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let category = self.categories[indexPath.row]
            self.showCategoryAlert(for: category)
            completionHandler(true)
        }
        
        editAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let category = self.categories[indexPath.row]
            
            self.context?.delete(category)
            do {
                try self.context?.save()
            } catch {
                print(error)
            }
            
            self.categories.remove(at: indexPath.row)
            self.selectedCategories.remove(category)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            selectedCategories.insert(category)
        } else {
            cell?.accessoryType = .none
            selectedCategories.remove(category)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

