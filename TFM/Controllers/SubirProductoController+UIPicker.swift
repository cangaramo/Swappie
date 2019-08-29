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
        uiPicker.backgroundColor = .white
        
        uiPicker.showsSelectionIndicator = true
        uiPicker.delegate = self
        uiPicker.dataSource = self
        
        /* Toolbar */
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 234/255, green: 144/255, blue: 133/255, alpha: 1)
        toolBar.sizeToFit()
        
        /* Actions */
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tallaTextField!.inputView = uiPicker
        tallaTextField!.inputAccessoryView = toolBar
        
    }
    
    /* Picker view metodos */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salutations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return salutations[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tallaTextField!.text = salutations[row]
    }
    
    /* Action done */
    
    @objc func donePicker() {
        tallaTextField!.resignFirstResponder()
    }
}
