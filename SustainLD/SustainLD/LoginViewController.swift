//
//  ViewController.swift
//  Skoovy
//
//  Created by Christopher Diaz on 1/12/17.
//  Copyright © 2017 Hot Salsa Interactive. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var next_btn: UIButton!
    
    @IBOutlet weak var username_txt: UITextField!
    
    @IBOutlet weak var password_text: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    let rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func auth_user(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: username_txt.text!, password: password_text.text!) { (user, error) in
            
            if(error == nil){
                
                //User exists
                NSLog("Login Successful")
            }
            else{
                
                // User does not exists
                self.statusLabel.isHidden = false
                self.statusLabel.text = "Wrong Username and/or Password"
                self.statusLabel.textColor = UIColor.red
                
            }
            
            
        }
        
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // hides keyboard if touch action happens outside of UITextView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Check for next field
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}

