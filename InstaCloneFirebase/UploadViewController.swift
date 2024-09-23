//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Farih Muhammad on 22/09/2024.
//

import UIKit
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    @IBAction func uploadClicked(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if let errorMessage = error {
                    print(errorMessage.localizedDescription)
                } else {
                    imageReference.downloadURL { url, error in
                        if let errorMessage = error {
                            print(errorMessage)
                        } else {
                            let imageUrl = url?.absoluteString
                            print(imageUrl)
                        }
                    }
                }
            }
        }
    }
    
}
