//
//  ViewController.swift
//  Flash Chat
//
//  Created by Tohid Fahim on 15/6/20.
//  Copyright © 2020 Tohid Fahim. All rights reserved.
//


import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    var keyboardHeight = CGFloat()
    var messageArray = [Message]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        messageTableView.register(UINib(nibName: "CustomMessageBackCell", bundle: nil), forCellReuseIdentifier: "customMessageBackCell")

        configureTableView()
        retriveMessage()
        
        //TODO: Disable Back
        navigationItem.hidesBackButton = true
        
        //TODO: Keyboard Height
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(handle(keyboardShowNotification:)),
        name: UIResponder.keyboardDidShowNotification,
        object: nil)
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email! {
            
            cell.messageBody.text = messageArray[indexPath.row].messageBody
            cell.senderUsername.text = messageArray[indexPath.row].sender
            cell.avatarImageView.image = UIImage(named: "egg")
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
            return cell
        }
            
        else{
            let newCell = tableView.dequeueReusableCell(withIdentifier: "customMessageBackCell", for: indexPath) as! CustomMessageBackCell
            
            newCell.messageBody.text = messageArray[indexPath.row].messageBody
            newCell.sendUsername.text = messageArray[indexPath.row].sender
            newCell.avatarImageView.image = UIImage(named: "egg")
            
            newCell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            newCell.messageBackground.backgroundColor = UIColor.flatGray()
            
            return newCell
        }
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }

    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 200.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = self.keyboardHeight + 50
            self.view.layoutIfNeeded()
            
            self.scrollToTop()
            self.messageTableView.reloadData()
        }
    }
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
       /// messageTextfield.isEnabled = false
       /// sendButton.isEnabled = false
        
        //TODO: Send the message to Firebase and save it in our database
        
        let messageDB = Database.database().reference().child("Messages")
        let messageDictionary = ["sender" : Auth.auth().currentUser?.email,
                                 "messageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            if error != nil {
                print(error!)
            }
            else {
                print("Message Saved")
                ///self.messageTextfield.isEnabled = true
                ///self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                self.scrollToTop()
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retriveMessage(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let sender = snapshotValue["sender"]!
            let text = snapshotValue["messageBody"]
            
            let message = Message()
            message.sender = sender
            message.messageBody = text!
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            self.scrollToTop()
        }
    }
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            let alert = UIAlertController(title: "Network Issue", message: "Logging Out Not Possible", preferredStyle: .alert)
            let action = UIAlertAction(title: "Try Again", style: .default) { (act) in
                self.logOutPressed(self)
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    // KEYBOARD HEIGHT
    @objc
    private func handle(keyboardShowNotification notification: Notification) {
        // 1
        print("Keyboard show notification")
        
        // 2
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    //Scroll to Top Tableview
    private func scrollToTop() {
        // 1
        if messageArray.count >= 1{
        let topRow = IndexPath(row: messageArray.count - 1 , section: 0)

        // 2
        self.messageTableView.scrollToRow(at: topRow, at: .bottom, animated: true)
        }
    }

}
