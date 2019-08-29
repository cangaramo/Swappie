//
//  EditarPerfilController+ImagePicker.swift
//  TFM
//
//  Created by Clarisa Angaramo on 01/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension EditarPerfilController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setImagePicker(){
        avatarImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarFoto)))
        avatarImageView!.isUserInteractionEnabled = true
    }
    
    /* PICK IMAGE */
    
    @objc func seleccionarFoto(sender:UIGestureRecognizer){
       // let avatarImageView = sender.view!
        
        //Open image picker
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //Recoger imagen seleccionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var selectedImageFromPicker: UIImage?
        
        //Edited
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
            //Original
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        //Set in image View
        if let selectedImage = selectedImageFromPicker {
           avatarImageView!.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
