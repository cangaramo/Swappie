//
//  SubirProductoController+UIPicker.swift
//  TFM
//
//  Created by Clarisa Angaramo on 28/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension SubirProductoController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func setUIPicker() {
        
        /*  Configurar picker */
        uiPicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
       uiPicker.backgroundColor = UIColor(rgb:0xf5f5f5)
        //uiPicker.backgroundColor = UIColor.white
        
        uiPicker.showsSelectionIndicator = true
        uiPicker.delegate = self
        uiPicker.dataSource = self
        
        /* Toolbar */
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(rgb:0x0f45b55)
        toolBar.barTintColor = UIColor.white
        toolBar.sizeToFit()
        
        /* Actions */
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tallaTextField!.inputView = uiPicker
        tallaTextField!.inputAccessoryView = toolBar
        
        estadoTextField!.inputView = uiPicker
        estadoTextField!.inputAccessoryView = toolBar
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont (name: "Raleway-Regular", size: 18)
        
        label.textAlignment = .center
        
        if (tallaTextField!.isFirstResponder){
            label.text =  tallas[row]
        }
        else {
            label.text =  estados[row]
        }
        
        return label
    }
    
    /* Picker view metodos */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (tallaTextField!.isFirstResponder){
           return tallas.count
        }
        else {
            return estados.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (tallaTextField!.isFirstResponder){
            return tallas[row]
        }
        else {
            return estados[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (tallaTextField!.isFirstResponder){
            tallaTextField!.text = tallas[row]
        }
        else if (estadoTextField!.isFirstResponder){
            estadoTextField!.text = estados[row]
        }
        
    }
    
    /* Action done */
    
    @objc func donePicker() {
        if (tallaTextField!.isFirstResponder){
            tallaTextField!.resignFirstResponder()
        }
        else if (estadoTextField!.isFirstResponder){
            estadoTextField!.resignFirstResponder()
        }
        
    }
}
