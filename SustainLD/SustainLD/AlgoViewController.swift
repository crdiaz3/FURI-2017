//
//  AlgoViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 4/3/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AlgoViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var algoTextField: UITextField!
    
    @IBOutlet weak var algoPickerView: UIPickerView!
    
    var pickerDataSource = ["AQI - Air Quality Index",
                            "MinT - Avg. Min Temp",
                            "MaxT - Avg. Max Temp",
                            "CI - Crime Index",
                            "LA - Land Area",
                            "WA - Water Area",
                            "PG - Pop. Growth"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureField()
        populateUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateUserInfo(){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        // Retrieve Name
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("userInfo").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstName = value?["firstName"] as? String ?? ""
            let lastName = value?["lastName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            
            curUser.firstName = firstName
            curUser.lastName = lastName
            curUser.email = email
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Retrieve Algorithms
        ref.child("algorithms").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            curUser.algorithms = (snapshot.value as? NSDictionary)!
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func configureField(){
        
        algoTextField?.addTarget(self, action: #selector(AlgoViewController.algoCheck), for: .editingChanged)
        
        // UITextField Styling
        algoTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        
    }
    
    func algoCheck(){
        
        // Check if algo has been changed
        if algoTextField.text! != "" {
            
            algoTextField.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
        } else {
            algoTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        

    @IBAction func signOutClicked(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "firstNavigationController")
        self.present(controller, animated: true, completion: nil)
    }
    
    // hides keyboard if touch action happens outside of UITextView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
