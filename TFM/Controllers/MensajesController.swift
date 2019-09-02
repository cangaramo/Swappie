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
    
    override func viewDidLoad() {
       // super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        observeUserMessages()
    }
    
    //Todos los mensajes
    var messages = [Mensaje]()
    
    //Mensajes agrupados
    var messagesDictionary = [String: Mensaje]()
    
    
    //Observe messages
    func observeUserMessages() {
        
        //Cogemos cualquier de los usuarios (TO y FROM)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        //Buscamos ese usuario en USER-MESSAGES
        let ref = Database.database().reference().child("usuario-mensajes").child(uid)
        
        //Loop mensaje
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos el mensaje
            let messageId = snapshot.key
            
            //Y ahora vamos a MESSAGES
            let messagesReference = Database.database().reference().child("mensajes").child(messageId)
            
            //Single
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Mensaje(dictionary: dictionary)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        //if let toId = message.toId {
                        //Esto se sobreescribe, por lo tanto solo tendremos un valor por toId
                        self.messagesDictionary[chatPartnerId] = message
                        
                        //Convertir en array
                        self.messages = Array(self.messagesDictionary.values)
                        
                        //Ordenar
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1.fecha?.intValue ?? 0 > message2.fecha?.intValue ?? 0
                        })
                    }
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
            print (self.messages)
            self.tableView?.reloadData()
        })
    }
}
