//
//  MensajesController+CollectionView.swift
//  TFM
//
//  Created by Clarisa Angaramo on 08/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension MensajesController: UITableViewDataSource, UITableViewDelegate {
    
    //TABLA
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UsuarioCell
        
        //Añadir mensaje a celda
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("usuarios").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = Usuario(dictionary: dictionary)
            user.id = chatPartnerId
            self.mostrarChatController(user: user)
            
        }, withCancel: nil)
        
    }
    
    func mostrarChatController(user: Usuario){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier :"chatController") as! ChatController
        chatController.usuario_other = user
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
}
