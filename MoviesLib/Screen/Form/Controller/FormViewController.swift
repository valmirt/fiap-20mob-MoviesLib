//
//  FormViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 26/09/20.
//

import UIKit

final class FormViewController: UIViewController {
    
    // MARK: - Properties
    var movie: Movie?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var btConclude: UIButton!
    @IBOutlet weak var scrollviewForm: UIScrollView!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupView() {
        if let movie = movie {
            title = "Editing Movie"
            tfTitle.text = movie.title
            tfDuration.text = movie.duration
            tvSummary.text = movie.summary
            tfRating.text = "\(movie.rating)"
            btConclude.setTitle("Update", for: .normal)
            ivPoster.image = movie.posterImage
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        scrollviewForm.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollviewForm.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    
    @objc
    private func keyboardWillHide() {
        scrollviewForm.contentInset.bottom = 0
        scrollviewForm.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - IBActions
    @IBAction func selectCategories(_ sender: UIButton) {
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Select image poster",
            message: "Where do you want to choose the image?",
            preferredStyle: .alert
        )
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Photo library", style: .default) { (_) in
            self.selectPictureFrom(.photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Photo Album", style: .default) { (_) in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancele", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context!)
        }
        movie?.title = tfTitle.text
        movie?.summary = tvSummary.text
        movie?.duration = tfDuration.text
        let rating = Double(tfRating.text!) ?? 0
        movie?.rating = rating
        movie?.image = ivPoster.image?.jpegData(compressionQuality: 0.9)
        
        view.endEditing(true)
        do {
            try context?.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
}

extension FormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            ivPoster.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

