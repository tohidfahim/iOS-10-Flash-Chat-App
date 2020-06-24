//
//  CustomMessageCell.swift
//  Flash Chat
//  Flash Chat
//
//  Created by Tohid Fahim on 15/6/20.
//  Copyright © 2020 Tohid Fahim. All rights reserved.
//


import UIKit

class CustomMessageBackCell: UITableViewCell {

    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var sendUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
    }

}
