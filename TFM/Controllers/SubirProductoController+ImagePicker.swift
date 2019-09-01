//
//  SubirProductoController+ImagePicker.swift
//  TFM
//
//  Created by Clarisa Angaramo on 28/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension SubirProductoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func setImagePickers(){
    
        /* Pick images */
       // previewImage1!.image = UIImage(named:"add-image.png")
       // previewImage2!.image = UIImage(named:"add-image.png")
       // previewImage3!.image = UIImage(named:"add-image.png")
        
        previewImage1!.tag = 1
        previewImage2!.tag = 2
        previewImage3!.tag = 3
        
        previewImage1!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarFoto)))
        previewImage2!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarFoto)))
        previewImage3!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarFoto)))
        
        previewImage1!.isUserInteractionEnabled = true
        previewImage2!.isUserInteractionEnabled = true
        previewImage3!.isUserInteractionEnabled = true
    }
    
    /* PICK IMAGE */
    
    @objc func seleccionarFoto(sender:UIGestureRecognizer){
        let imageView = sender.view!
        current_pick_image = imageView.tag
        
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
            
            switch(current_pick_image) {
                
            case (1):
                previewImage1!.image = selectedImage
                selected_images.append(selectedImage)
                break
                
            case (2):
                previewImage2!.image = selectedImage
                selected_images.append(selectedImage)
                break
                
            case (3):
                previewImage3!.image = selectedImage
                selected_images.append(selectedImage)
                break
                
            default:
                print ("No image")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
