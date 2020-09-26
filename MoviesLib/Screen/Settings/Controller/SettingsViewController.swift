//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 26/09/20.
//
import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - IBOutlets
    @IBOutlet weak var switchAutoPlay: UISwitch!
    @IBOutlet weak var scColors: UISegmentedControl!
    @IBOutlet weak var tfCategory: UITextField!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Methods
    private func setupView() {
        switchAutoPlay.isOn = userDefaults.bool(forKey: "autoplay")
        scColors.selectedSegmentIndex = userDefaults.integer(forKey: "color")
        tfCategory.text = userDefaults.string(forKey: "category")
    }
    
    
    // MARK: - IBActions
    @IBAction func switchAutoPlay(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "autoplay")
    }
    
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        userDefaults.set(sender.selectedSegmentIndex, forKey: "color")
    }
    
    @IBAction func categoryChanged(_ sender: UITextField) {
        userDefaults.set(sender.text, forKey: "category")
        sender.resignFirstResponder()
    }
}

