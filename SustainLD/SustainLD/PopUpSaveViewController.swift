//
//  PopUpSaveViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 4/14/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PopUpSaveViewController: UIViewController {
    
    var passedAlgoName:String!
    var presentingSegue:String!

    @IBOutlet weak var deleteNameTextField: UITextField!
    @IBOutlet weak var saveNameTextField: UITextField!
    @IBOutlet weak var saveNRunNameTextField: UITextField!
    
    @IBOutlet weak var saveYesButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    
    @IBOutlet weak var saveNRunYesButton: UIButton!
    @IBOutlet weak var saveNRunLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFields(){
        
        // Delete View
        if(presentingSegue == "deleteSegue"){
            deleteNameTextField?.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
            deleteNameTextField?.text = passedAlgoName
        }
        // Save View
        else if(presentingSegue == "saveSegue"){
            saveNameTextField?.addTarget(self, action: #selector(PopUpSaveViewController.saveNameCheck), for: .editingChanged)
            saveNameTextField?.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
            saveNameTextField?.text = passedAlgoName
            saveNameCheck()
        }
        
        // Save & Run View
        else if(presentingSegue == "saveNRunSegue"){
            saveNRunNameTextField?.addTarget(self, action: #selector(PopUpSaveViewController.saveNRunNameCheck), for: .editingChanged)
            saveNRunNameTextField?.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
            saveNRunNameTextField?.text = passedAlgoName
            saveNRunNameCheck()
        }
        
        
    }
    
    func saveNameCheck(){
        // Save Popup View
        
        if(saveNameTextField.text != ""){
            saveNameTextField.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
            
            let user = FIRAuth.auth()?.currentUser
            
            FIRDatabase.database().reference().child("algorithms").child((user?.uid)!).child(self.saveNameTextField.text!).observeSingleEvent(of: .value, with: {(algoNameSnap) in
                
                self.saveYesButton.isEnabled = false
                
                if algoNameSnap.exists(){
                    // Username already exists
                    self.saveLabel.text = "Saving will overwrite algorithm"
                    self.saveYesButton.isEnabled = true
                    
                } else if !algoNameSnap.exists(){
                    // Username does not exist
                    self.saveLabel.text = "Saving will create new algorithm"
                    self.saveYesButton.isEnabled = true
                }
                
            })
            
        } else {
            saveNameTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
            saveYesButton.isEnabled = false
            self.saveLabel.text = ""
        }
    }
    
    func saveNRunNameCheck(){
        
        // Save & Run Popup View
        if(saveNRunNameTextField.text != ""){
            saveNRunNameTextField.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
            
            let user = FIRAuth.auth()?.currentUser
            
            FIRDatabase.database().reference().child("algorithms").child((user?.uid)!).child(self.saveNRunNameTextField.text!).observeSingleEvent(of: .value, with: {(algoNameSnap) in
                
                self.saveNRunYesButton.isEnabled = false
                
                if algoNameSnap.exists(){
                    // Username already exists
                    self.saveNRunLabel.text = "Saving will overwrite algorithm"
                    self.saveNRunYesButton.isEnabled = true
                    
                } else if !algoNameSnap.exists(){
                    // Username does not exist
                    self.saveNRunLabel.text = "Saving will create new algorithm"
                    self.saveNRunYesButton.isEnabled = true
                }
                
            })
            
        } else {
            saveNRunNameTextField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
            saveNRunYesButton.isEnabled = false
            self.saveNRunLabel.text = ""
        }
    }
    
    // Actions
    @IBAction func deleteYesButtonClicked(_ sender: Any) {
        let deletedAlgo = self.deleteNameTextField.text!
        FIRDatabase.database().reference().child("algorithms").child(FIRAuth.auth()!.currentUser!.uid).child(self.deleteNameTextField.text!).removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error!)
            } else {
                let alert = UIAlertController(title: "Delete Successfull", message: deletedAlgo + " has been deleted.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: self.deleted))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func deleted(alert: UIAlertAction!){
        performSegue(withIdentifier: "backToAlgoControllerSegue", sender: self)
    }
    
    @IBAction func saveYesButtonClicked(_ sender: Any) {
    }
    
    @IBAction func saveNRunYesButtonClicked(_ sender: Any) {
    }
    
    @IBAction func noClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let algoController = segue.destination as! AlgoViewController
        algoController.populateUserInfo()
    }
    

}
