//
//  ChatController+TextField.swift
//  TFM
//
//  Created by Clarisa Angaramo on 18/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension ChatController: UITextFieldDelegate {
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //Esconder y mostrar teclados
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        //Cambiar boton de Enviar
        if (textField.text!.isEmpty){
            sendButton!.backgroundColor = UIColor(rgb:0xdedede)
            sendButton!.setImage(UIImage(named: "white-send"), for: UIControl.State.normal)
            sendButton?.isEnabled = false
        }
        else {
            sendButton!.backgroundColor = UIColor(rgb:0xFCE1DA)
            sendButton!.setImage(UIImage(named: "send"), for: UIControl.State.normal)
            sendButton?.isEnabled = true
        }
    }
    
    func animateTextField(textField: UIView, up: Bool)
    {
        let tabbarhHeight = CGFloat (50)
        let totalDistance = tabbarhHeight + 160
        let movementDistance:CGFloat = -totalDistance
        var movementDuration: Double = 0
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
            movementDuration = 0.5
        }
        else
        {
            movement = -movementDistance
            movementDuration = 0.25
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
