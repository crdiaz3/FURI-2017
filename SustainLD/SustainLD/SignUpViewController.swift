//
//  SignUpViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 2/28/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var validEmailLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var validPasswordLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Setup textFields to run the checkFields method when fields are edited
    func configureFields(){
        // Name View Config
        
        passwordField?.addTarget(self, action: #selector(SignUpViewController.checkEmailPwFields), for: .editingChanged)
        
        confirmPasswordField?.addTarget(self, action: #selector(SignUpViewController.checkEmailPwFields), for: .editingChanged)
        
        // Email View Config
        signUpButton?.isEnabled = false
        
        emailField?.addTarget(self, action: #selector(SignUpViewController.checkEmailPwFields), for: .editingChanged)
        
    }
    
    
    // Enable button when number has been entered into phone textField
    func checkEmailPwFields(){
        if emailField.text! != ""{
            if !isValidEmailAddress(curEmail: emailField.text!) {
                signUpButton.isEnabled = false
                self.validEmailLabel.text = "Invalid email"
                self.validEmailLabel.textColor = UIColor.red
                
            } else {
                self.validEmailLabel.text = "Valid email"
                self.validEmailLabel.textColor = UIColor.green
                curUser.email = emailField.text!
                passwordCheck()
            }
        } else {
            validEmailLabel.text = "An email must be entered"
            validEmailLabel.textColor = UIColor.darkGray
        }
    }
    
    func isValidEmailAddress(curEmail:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: curEmail)
    }
    
    // Enable next button when valid password has been entered into fields
    func passwordCheck() {
        if passwordField.text! == "" || passwordField.text! == "" {
            signUpButton.isEnabled = false
        } else if self.passwordField.text!.characters.count < 5 {
            // password must be at least 5 characters
            validPasswordLabel.text = "Password must be at least 5 characters"
            validEmailLabel.textColor = UIColor.red
            signUpButton.isEnabled = false
            
        } else if passwordField.text! != confirmPasswordField.text! {
            // Passwords don't match
            validPasswordLabel.text = "Password do not match"
            validPasswordLabel.textColor = UIColor.red
            signUpButton.isEnabled = false
            
        } else {
            validPasswordLabel.text = "Valid password"
            validPasswordLabel.textColor = UIColor.green
            signUpButton.isEnabled = true
            curUser.email = emailField.text!
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        curUser.addUserToFirebase(password: passwordField.text!)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
