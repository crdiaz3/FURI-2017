//
//  ViewController.swift
//  Skoovy
//
//  Created by Christopher Diaz on 1/12/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var nextbutton: UIButton!
    
    let rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func authenticateUser(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            
            if(error == nil){
                
                //User exists
                NSLog("Login Successful")
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            }
            else{
                // User does not exists
                self.statusLabel.isHidden = false
                self.statusLabel.text = "Wrong Username and/or Password"
                self.statusLabel.textColor = UIColor.red
                
            }
            
            
        }

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Check for next field
        if(textField.tag == 1){
            authenticateUser(self)
        }
        else if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    // hides keyboard if touch action happens outside of UITextView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

