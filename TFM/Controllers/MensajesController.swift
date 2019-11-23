//
//  MensajesController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 08/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MensajesController:UIViewController {
    
    @IBOutlet var tableView:UITableView?
    @IBOutlet var mensajeView:UIView?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        mensajeView?.isHidden = true
        
        observeUserMessages()
    }
    
    //Todos los mensajes
    var messages = [Mensaje]()
    
    //Mensajes agrupados
    var messagesDictionary = [String: Mensaje]()
    
    
    //Observamos mensajes
    func observeUserMessages() {
        
        //Cogemos cualquier de los usuarios (TO y FROM)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        //Buscamos ese usuario en Usuario-Intercambios
        let refMensajes = Database.database().reference().child("usuario-mensajes")
        refMensajes.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //El usuario tiene intercambios
            if (snapshot.hasChild(uid)) {
                self.mensajeView?.isHidden = true
            }
            //El usuario no tiene intercambios
            else {
                self.mensajeView?.isHidden = false
            }
        
        }, withCancel: nil)
        
        //Si tiene intercambios
        let ref = Database.database().reference().child("usuario-mensajes").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos el mensaje
            let messageId = snapshot.key
            
            let messagesReference = Database.database().reference().child("mensajes").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Mensaje(dictionary: dictionary)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        
                        //Agrupar mensajes
                        self.messagesDictionary[chatPartnerId] = message
                        
                        //Convertir en array
                        self.messages = Array(self.messagesDictionary.values)
                        
                        //Ordenar
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1.fecha?.intValue ?? 0 > message2.fecha?.intValue ?? 0
                        })
                    }
                    
                    //Configurar timer
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
        })
    }
}
