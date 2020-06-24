//
//  CustomMessageCell.swift
//  Flash Chat
//  Flash Chat
//
//  Created by Tohid Fahim on 15/6/20.
//  Copyright © 2020 Tohid Fahim. All rights reserved.
//


import UIKit

class CustomMessageCell: UITableViewCell {


    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
