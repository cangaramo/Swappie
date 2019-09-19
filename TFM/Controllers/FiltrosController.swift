//
//  FiltrosController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 03/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

class FiltrosController:UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var tallaTextField:UITextField?
    @IBOutlet var distanciaLabel:UILabel?
    var uiPicker : UIPickerView!
    @IBOutlet var estado1:UIView?
    @IBOutlet var estado2:UIView?
    @IBOutlet var estado3:UIView?
    @IBOutlet var estado4:UIView?
    @IBOutlet var slider:UISlider?
    
    let tallas = ["", "XXS", "XS", "S", "M", "L", "XL", "XXL"]
    var talla_seccionada = ""
    
    let estados = ["Sin estrenar", "Apenas usado", "En muy buen estado", "Bastante usado"]
    var estados_seleccionados = [String]()
    
    var distancia_seleccionada = 20
    
    var devolverFiltros : ( (String, [String], Int) -> Void)?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (talla_seccionada != ""){
            tallaTextField?.text = talla_seccionada
        }
        
        if (!estados_seleccionados.isEmpty){
            
            for estado_seleccionado in estados_seleccionados {
                var index = 1
                for estado in estados {
                    if (estado_seleccionado == estado){
                        print ("sasa")
                        print (index)
                        if let container_view = self.view.viewWithTag(index) as? UIView {
                            container_view.backgroundColor =  UIColor(rgb:0x5446D9)
                          //  container_view.backgroundColor = UIColor(rgb:0x5446D9)
                        }
                    }
                    index = index + 1
                }
                
            }
        }
        
        if (distancia_seleccionada != 20) {
            print ("distancia")
            print (distancia_seleccionada)
            slider?.setValue(Float(distancia_seleccionada), animated: true)
            distanciaLabel!.text = "\(distancia_seleccionada)" + " km"
            //distancia_seleccionada = currentValue
            
        }
        
        setUIPicker()
    
        //Añadir Gesture Recognizer
        estado1!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("seleccionarEstado:"))))
        estado2!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("seleccionarEstado:"))))
        estado3!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("seleccionarEstado:"))))
        estado4!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("seleccionarEstado:"))))
    }
    
    
    //Checkboxes - Estado
    @objc func seleccionarEstado(_ sender:UITapGestureRecognizer){
        let container_view = sender.view
        let checkboxes = container_view!.subviews.compactMap { $0 as? UIView }
        let checkbox = checkboxes[0]

        let tag = checkbox.tag
        let estado_selected = estados[tag-1]
        
        //Comprobar si ya esta en el array
        var encontrado = false
        var pos = 0
        for estado in estados_seleccionados {
            if (estado == estado_selected) {
                encontrado = true
                break
            }
            pos = pos + 1
        }
        
        //Deseleccionar
        if (encontrado) {
            estados_seleccionados.remove(at: pos)
            checkbox.backgroundColor = UIColor.white
            
        }
        //Seleccionar
        else {
            estados_seleccionados.append(estado_selected)
            checkbox.backgroundColor = UIColor(rgb:0x5446D9)
        }
        
    }
    
    /* Slider - Distancia */
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        distanciaLabel!.text = "\(currentValue)" + " km"
        distancia_seleccionada = currentValue
    }
    
    
    /* UIPicker - Tallas */
    func setUIPicker() {
        
        /*  Configurar picker */
        uiPicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        uiPicker.backgroundColor = UIColor(rgb:0xf5f5f5)
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
        
        /* Acciones */
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tallaTextField!.inputView = uiPicker
        tallaTextField!.inputAccessoryView = toolBar
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: tallaTextField!, border_color: border_color)
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
        
        talla_seccionada = tallas[row]
     
        return label
    }
    
    /* Picker view metodos */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return tallas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return tallas[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        tallaTextField!.text = tallas[row]
    }
    
    /* Action done */
    
    @objc func donePicker() {
        if (tallaTextField!.isFirstResponder){
            tallaTextField!.resignFirstResponder()
        }
    }
    
    
    @IBAction func filtrosDone(){
        print (distancia_seleccionada)
        self.devolverFiltros!(talla_seccionada, estados_seleccionados, distancia_seleccionada)
        self.navigationController?.popViewController(animated: true)
    }
}
