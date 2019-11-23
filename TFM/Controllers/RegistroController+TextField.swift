//
//  RegistroController+TextField.swift
//  TFM
//
//  Created by Clarisa Angaramo on 17/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension RegistroController: UITextFieldDelegate {
    
    /* Text Fields */
    
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
    
    //Pasar al siguiente TextField cuando se presiona return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch (textField.tag){
        case 1:
            emailTextField?.becomeFirstResponder()
            break
        case 2:
            contrasenaTextField!.becomeFirstResponder()
            break
        case 3:
            textField.resignFirstResponder()
            registrarUsuario()
            break
        default:
            textField.resignFirstResponder()
        }
        
        //No añadir salto de línea
        return false
    }
    
    //Animar text field cuando se muestra el teclado
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
    
    //Añadir borde cuando text field esté activo
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
