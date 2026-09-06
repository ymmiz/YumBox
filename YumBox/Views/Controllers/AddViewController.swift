//
//  AddViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 26/09/2024.
//

import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var cameraBtn: UIButton!
    var selectedImageData: Data?
    var selectedFileExtension: String = "jpeg"
    var viewModel = RecipeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: "Pick an image from photo library or camera.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }))
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.showImagePicker(sourceType: .camera)}))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = cameraBtn.frame
            popoverController.permittedArrowDirections = .any
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            previewImage.image = image
            selectedFileExtension = "jpeg"
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let imageExtension = imageURL.pathExtension.lowercased()
                if imageExtension == "heic" {
                    selectedImageData = image.jpegData(compressionQuality: 0.8)
                    selectedFileExtension = "jpeg"
                } else if imageExtension == "jpeg" || imageExtension == "jpg" {
                    selectedImageData = image.jpegData(compressionQuality: 0.8)
                } else {
                    selectedImageData = image.pngData()
                    selectedFileExtension = "png"
                }
            } else {
                selectedImageData = image.jpegData(compressionQuality: 0.8)
                selectedFileExtension = "jpeg"
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: Any) {
        let item = SavedRecipe(name: itemName.text ?? "Item" , image: (previewImage.image ?? UIImage(systemName: "photo"))!)
        Share.append(item)
        let title = item.name
        DispatchQueue.global(qos: .background).async {
            self.viewModel.uploadToWebsite(title: title, fileExtension: self.selectedFileExtension, imageData: self.selectedImageData ?? Data())
        }
        navigationController?.popViewController(animated: true)
    }
}
