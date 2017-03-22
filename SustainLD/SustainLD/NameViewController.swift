//
//  NameViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 3/19/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFields(){
        // Name View Config
        
        firstNameField?.addTarget(self, action: #selector(NameViewController.nameCheck), for: .editingChanged)
        
        lastNameField?.addTarget(self, action: #selector(NameViewController.nameCheck), for: .editingChanged)
        
        // Email View Config
        nextButton?.isEnabled = false
        
    }
    
    func nameCheck(){
        if firstNameField.text! != "" && lastNameField.text! != "" {
            nextButton.isEnabled = true
            curUser.firstName = firstNameField.text!
            curUser.lastName = lastNameField.text!
        }
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