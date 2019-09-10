//
//  IniciarSesionController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase

class IniciarSesionController: ViewController, UITextFieldDelegate{
    
    @IBOutlet var emailTextField:UITextField?
    @IBOutlet var contrasenaTextField:UITextField?
    @IBOutlet var inicioSesionButton:UIButton?
    
    override func viewDidLoad(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear 
        
        inicioSesionButton!.addTarget(self, action: #selector(iniciarSesion), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
        emailTextField?.delegate = self
        contrasenaTextField?.delegate = self
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: emailTextField!, border_color: border_color)
        addBorder(textField: contrasenaTextField!, border_color: border_color)
    }
    
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
    
    @objc func iniciarSesion(){
        
        guard let email = emailTextField!.text, let contrasena = contrasenaTextField!.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: contrasena, completion: { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            //successfully logged in our user
            
            //Mostrar menu
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabMenu = (storyboard.instantiateViewController(withIdentifier: "tabMenu") as? UITabBarController) {
                self.present(tabMenu, animated: true, completion: nil)
            }

        })
    }
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
