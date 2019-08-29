//
//  UsuarioCell.swift
//  TFM
//
//  Created by Clarisa Angaramo on 08/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class UsuarioCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView?
    @IBOutlet var userDetailTextLabel: UILabel?
    @IBOutlet var userTextLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    
    var message:Mensaje? {
        
        didSet {
            
            //User name
            setupNameAndProfileImage()
            
            //Message details
            self.userDetailTextLabel?.text = message?.texto
            
            //Timestamp
            //self.timeLabel?.text = message?.timestamp?.stringValue
            
            if let seconds = message?.fecha?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.timeLabel?.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    //Comprobar quien es el partner (TO o FROM)
    fileprivate func setupNameAndProfileImage() {
        
        /*
         let chatPartnerId: String?
         
         if message?.fromId == Auth.auth().currentUser?.uid {
         chatPartnerId = message?.toId
         } else {
         chatPartnerId = message?.fromId
         }*/
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("usuarios").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.userTextLabel?.text = dictionary["nombre"] as? String
                    
                    if let profileImageUrl = dictionary["imagen"] as? String {
                        self.profileImageView?.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }
    
    //To add extra styles
    override func awakeFromNib() {
        self.profileImageView?.layer.cornerRadius = 26
        
    }
    
    
}
