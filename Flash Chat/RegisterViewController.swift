//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.placeholder = "Put Your Email Here"
        passwordTextfield.placeholder = "Your Password Should be 6 Characters Long"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil{
                print(error!)
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Invalid", message: "Email or Password", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default) { (act) in
                    self.emailTextfield.text = ""
                    self.passwordTextfield.text = ""
                }
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                self.emailTextfield.text = ""
                self.passwordTextfield.text = ""
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        

        
        
    } 
    
    
}
