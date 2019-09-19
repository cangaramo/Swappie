//
//  IniciarSesion+TextField.swift
//  TFM
//
//  Created by Clarisa Angaramo on 19/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension IniciarSesionController: UITextFieldDelegate {
    
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
    
    /* Text field */
    
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
        
        switch (textField.tag){
        case 1:
            contrasenaTextField?.becomeFirstResponder()
            break
        case 2:
            textField.resignFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
}
