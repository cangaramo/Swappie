//
//  ChatController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 08/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatController:UIViewController, UITextFieldDelegate{
    
    @IBOutlet var collectionView:UICollectionView?
    
    @IBOutlet var sendButton:UIButton?
    @IBOutlet var inputTextField:UITextField?
    
    var mensajes = [Mensaje]()
    
    //User
    var usuario_other:Usuario? {
        didSet {
            navigationItem.title = usuario_other?.nombre
            observeMessages()
        }
    }
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        
        print ("holaaa")
        //self.hideKeyboardWhenTappedAround()
        
        inputTextField?.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        collectionView!.addGestureRecognizer(tapGesture)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMensajeCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:false)
        
    }
    
    func animateTextField(textField: UIView, up: Bool)
    {
        //let tabbarhHeight = CGFloat ((tabBarController?.tabBar.frame.size.height)!)
       // print (tabbarhHeight)
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
    
    //Observe messages
    func observeMessages() {
        
        print ("observar mensajes")
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("usuario-mensajes").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("mensajes").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let mensaje = Mensaje(dictionary: dictionary)
                
                if mensaje.chatPartnerId() == self.usuario_other?.id {
                    
                    self.mensajes.append(mensaje)
                    
                    DispatchQueue.main.async(execute: {
                        print (self.mensajes)
                      
                        self.collectionView?.reloadData()
                        
                        //Scroll to the bottom
                        var lastItemIndex = NSIndexPath(item: self.mensajes.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
                    })
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //Send message
    @IBAction func handleSend(){
        
        if (inputTextField!.text! != "" ) {
            
            let ref = Database.database().reference().child("mensajes")
            let childRef = ref.childByAutoId()
            
            //is it there best thing to include the name inside of the message node
            let destinatarioId = usuario_other!.id
            let remitenteId = Auth.auth().currentUser!.uid
            let fecha = Int(Date().timeIntervalSince1970)
            
            let values = ["texto": inputTextField!.text!, "destinatarioId": destinatarioId, "remitenteId": remitenteId, "fecha": fecha] as [String : Any]
            
            //Old: anyadir a mensajes y ya esta
            //childRef.updateChildValues(values)
            
            //Anyadir primero a MENSAJES
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                self.inputTextField!.text = nil
                
                //Necesitamos la key para USER MENSAJES
                guard let messageId = childRef.key else { return }
                
                //Anyadir usuario FROM
                let userMessagesRef = Database.database().reference().child("usuario-mensajes").child(remitenteId).child(messageId)
                userMessagesRef.setValue(1)
                
                //Anyadir usuario TO
                let recipientUserMessagesRef = Database.database().reference().child("usuario-mensajes").child(destinatarioId!).child(messageId)
                recipientUserMessagesRef.setValue(1)
            }
        }
    }
}
