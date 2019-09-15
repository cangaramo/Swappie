//
//  SubirProducto+TextField.swift
//  TFM
//
//  Created by Clarisa Angaramo on 15/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension SubirProductoController: UITextViewDelegate, UITextFieldDelegate {
    
    /* Métodos */
    func animateTextField(textField: UIView, up: Bool)
    {
        let movementDistance:CGFloat = -100
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
    
    /* Text fields */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.tag == 3 ) {
            
            textField.resignFirstResponder()
            
            irACategorias()
        }
        else {
            let border_color = UIColor(rgb: 0x5446D9)
            addBorder(textField: textField, border_color: border_color)
            self.animateTextField(textField: textField, up:true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch (textField.tag){
        case 0:
            descripcionTexView?.becomeFirstResponder()
            break
        case 1:
            marcaTextField?.becomeFirstResponder()
            break
        case 2:
            textField.resignFirstResponder()
            irACategorias()
            break
        case 3:
            tallaTextField?.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
    
    
    /* Text view */
    func textViewDidBeginEditing(_ textView: UITextView) {
        /*
         if descripcionTexView!.textColor == UIColor.lightGray {
         descripcionTexView!.text = nil
         descripcionTexView!.textColor = UIColor.black
         }*/
        
        let border_color = UIColor(rgb: 0x5446D9)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTexView!.textColor == UIColor.lightGray {
            descripcionTexView!.text = nil
            descripcionTexView!.textColor = UIColor.black
        }
        
        self.animateTextField(textField: textView, up:true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        /*
         if descripcionTexView!.text.isEmpty {
         descripcionTexView!.text = "Añade una descripción"
         descripcionTexView!.textColor = UIColor.lightGray
         }*/
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTexView!.text.isEmpty {
            descripcionTexView!.text = "Añade una descripción"
            descripcionTexView!.textColor = UIColor.lightGray
        }
        
        self.animateTextField(textField: textView, up:false)
    }
}
