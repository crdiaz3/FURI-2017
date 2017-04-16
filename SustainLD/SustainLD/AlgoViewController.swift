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

class AlgoViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var algoSelectBox: UITextField!
    @IBOutlet weak var algoDropDown: UIPickerView!
    
    @IBOutlet weak var algoTextField: UITextField!
    
    @IBOutlet weak var sustainPickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveNRunButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var newUser:Bool!
    
    var pickerDataSource = ["AQI - Air Quality Index",
                            "MinT - Avg. Min Temp",
                            "MaxT - Avg. Max Temp",
                            "CI - Crime Index",
                            "LA - Land Area",
                            "WA - Water Area",
                            "PG - Pop. Growth"];
    
    var algoPickerSource = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveButton.isEnabled = false
        saveNRunButton.isEnabled = false
        deleteButton.isEnabled = false
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
        
        NSLog(String(describing: userID))
        
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
            if ((snapshot.value) as? NSDictionary) != nil  {
                curUser.algorithms = (snapshot.value as? NSDictionary)!
                
                self.algoPickerSource = curUser.algorithms.allKeys as! [String]
                self.algoDropDown.reloadAllComponents()
                var runningAlgo = false
                for (key,_) in curUser.algorithms {
                    let innerDict=curUser.algorithms.value(forKey: key as! String) as! NSDictionary
                    if(innerDict["running"] as? Bool == true){
                        self.algoSelectBox.text = key as? String
                        self.algoTextField.text = innerDict.value(forKey: "formula") as? String
                        curUser.runningAlgo = (key as? String)!
                        runningAlgo = true
                    }
                }
                
                if(!runningAlgo){
                    self.algoSelectBox.text = curUser.algorithms.allKeys[0] as? String
                    
                    let innerDict = curUser.algorithms.value(forKey: self.algoSelectBox.text!) as! NSDictionary
                    self.algoTextField.text = innerDict.value(forKey: "formula") as? String
                    
                }
                self.deleteButton.isEnabled = true
            } else {
                NSLog("No Algos")
                curUser.runningAlgo = ""
                self.deleteButton.isEnabled = false
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func configureField(){
        
        algoTextField?.addTarget(self, action: #selector(AlgoViewController.algoCheck), for: .editingChanged)
        
        // UITextField Styling
        algoTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        
        algoSelectBox.addBottomBorderWithColor(color: UIColor.black, width: 2)
        
        algoDropDown?.isHidden = true
    }
    
    func algoCheck(){
        
        // Check if algo has been changed
        if algoTextField.text! != "" {
            saveButton.isEnabled = true
            saveNRunButton.isEnabled = true
            algoTextField.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
        } else {
            algoTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
            saveButton.isEnabled = false
            saveNRunButton.isEnabled = false
        }
    }
    
    @IBAction func saveNRunClicked(_ sender: Any) {
        performSegue(withIdentifier: "saveNRunSegue", sender: self)

    }
    
    @IBAction func saveClicked(_ sender: Any) {
        performSegue(withIdentifier: "saveSegue", sender: self)
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        performSegue(withIdentifier: "deleteSegue", sender: self)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        
        if(pickerView == sustainPickerView){
            count = pickerDataSource.count
        } else if(pickerView == algoDropDown){
            count = algoPickerSource.count
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        
        if(pickerView == sustainPickerView){
            title = pickerDataSource[row]
        } else if(pickerView == algoDropDown){
            self.view.endEditing(true)
            title = algoPickerSource[row]
        }
        
        return title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == algoDropDown){
            self.algoSelectBox.text = self.algoPickerSource[row]
            
            let innerDict=curUser.algorithms.value(forKey: self.algoPickerSource[row]) as! NSDictionary
            self.algoTextField.text = innerDict.value(forKey: "formula") as? String
            self.algoDropDown.isHidden = true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.algoSelectBox {
            self.algoDropDown.isHidden = !self.algoDropDown.isHidden
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
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
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let modal = segue.destination as! PopUpSaveViewController
        modal.presentingSegue = segue.identifier
        modal.passedAlgoName = self.algoSelectBox.text!
        modal.passedFormula = self.algoTextField.text!
    }
    

}
