//
//  EditarPefilController+TextField.swift
//  TFM
//
//  Created by Clarisa Angaramo on 17/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension EditarPerfilController:  UITextViewDelegate, UITextFieldDelegate {
    
    /* TEXT FIELD */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let border_color = UIColor(rgb: 0x5446D9)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:false)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else if let nextView = textField.superview?.viewWithTag(textField.tag + 1) as? UITextView  {
            nextView.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    /* TEXT VIEW */
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let border_color = UIColor(rgb: 0x5446D9)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTextView!.textColor == UIColor.lightGray {
            descripcionTextView!.text = nil
            descripcionTextView!.textColor = UIColor.black
        }
        
        self.animateTextField(textField: textView, up:true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTextView!.text.isEmpty {
            descripcionTextView!.text = "Añade una descripción"
            descripcionTextView!.textColor = UIColor.lightGray
        }
        
        self.animateTextField(textField: textView, up:false)
    }
    
    /* Métodos */
    
    func animateTextField(textField: UIView, up: Bool)
    {
        let movementDistance:CGFloat = -200
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func addBorder(textField: UIView, border_color: UIColor){
        let width = CGFloat(1.0)
        let border = CALayer()
        border.borderColor = border_color.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
}
