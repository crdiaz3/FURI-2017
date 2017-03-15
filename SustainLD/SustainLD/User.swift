//
//  User.swift
//  SustainLD
//
//  Created by Christopher Diaz on 2/28/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import Foundation
import Foundation
import FirebaseAuth
import FirebaseDatabase

class User {
    var email: String
    var firstName: String
    var lastName: String
    
    init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
    }
    
    func addUserToFirebase(password newPassword:String){
        
        FIRAuth.auth()?.createUser(withEmail: curUser.email, password: newPassword, completion: { (user: FIRUser?, error) in
            if error == nil {
                //registration successful
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference().child("userInfo").child((user?.uid)!)
                
                ref.child("email").setValue(curUser.email)
                
            }else{
                // Registration failure
                NSLog("Failed to add: " + curUser.email)
            }
        })
        
    }
    
}

var curUser = User()
