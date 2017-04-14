//
//  ViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 2/27/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*if (FIRAuth.auth()?.currentUser) != nil {
            // segue to main view controller
            self.performSegue(withIdentifier: "alreadyLoggedInSegue", sender: self)
        } else {
            // sign in
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FIRAuth.auth()?.currentUser) != nil {
            // segue to main view controller
            self.performSegue(withIdentifier: "alreadyLoggedInSegue", sender: self)
        } else {
            // sign in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

