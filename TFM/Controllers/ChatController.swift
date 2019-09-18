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

class ChatController:UIViewController {
    
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
       
        inputTextField?.delegate = self
        inputTextField?.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

        //Collection View
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMensajeCell.self, forCellWithReuseIdentifier: "cellId")
        
        //Esconder teclado cuando se toca la tabla
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        collectionView!.addGestureRecognizer(tapGesture)
    }
    
    
    
    //Observe messages
    func observeMessages() {
        
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
            
            //Valores
            let destinatarioId = usuario_other!.id
            let remitenteId = Auth.auth().currentUser!.uid
            let fecha = Int(Date().timeIntervalSince1970)
            
            let values = ["texto": inputTextField!.text!, "destinatarioId": destinatarioId, "remitenteId": remitenteId, "fecha": fecha] as [String : Any]
        
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
