//
//  User.swift
//  SustainLD
//
//  Created by Christopher Diaz on 2/28/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class User {
    var email: String
    var firstName: String
    var lastName: String
    var algorithms: NSDictionary
    
    init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.algorithms = [String: NSDictionary]() as NSDictionary
    }
    
    func addUserToFirebase(password newPassword:String) -> Bool {
        
        var success: Bool
        success = false
        
        FIRAuth.auth()?.createUser(withEmail: curUser.email, password: newPassword, completion: { (user: FIRUser?, error) in
            if error == nil {
                //registration successful
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference().child("userInfo").child((user?.uid)!)
                ref.child("firstName").setValue(curUser.firstName)
                ref.child("lastName").setValue(curUser.lastName)
                ref.child("email").setValue(curUser.email)
                success = true
                
            }else{
                // Registration failure
                NSLog("Failed to add: " + curUser.email)
                success = false
            }
        })
        
        return success
        
    }
    
}

var curUser = User()
