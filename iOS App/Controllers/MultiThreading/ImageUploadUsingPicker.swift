//
//  File.swift
//  iOS App
//
//  Created by Qualwebs on 30/01/24.
//

import Foundation
import UIKit

extension PlaygroundViewController{
    // profile image selceting function
    func showImagePickerOptions(){
        let alertVC = UIAlertController(title: "Pick a photo", message: "Choose a picture from library or camera", preferredStyle: .actionSheet)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                let cameraImagePicker = self.imagePicker(sourceType: .camera)
                cameraImagePicker.delegate = self
                self.present(cameraImagePicker, animated: true)
            }
            alertVC.addAction(cameraAction)
        }else{
            print("Camera is not avaiable..")
        }
        
        let libraryAction = UIAlertAction(title: "Gallery", style: .default) { action in
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.allowsEditing = true
            libraryImagePicker.delegate = self
            
            self.present(libraryImagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
}

//MARK: Extension imagepicker
extension PlaygroundViewController: UIImagePickerControllerDelegate ,  UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        self.sampleImage.image = image
        self.dismiss(animated: true, completion: nil)
        
        let imageData = image?.jpegData(compressionQuality: 0.5)
        uploadImage(fileData: imageData)
    }
}

//Extension for Data append
extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
