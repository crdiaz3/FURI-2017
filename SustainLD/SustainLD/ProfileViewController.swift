//
//  ProfileViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 4/3/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reTypePasswordField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var aTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUserInfo()
        configureFields()
        configureImage()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return curUser.algorithms.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        
        // Create an object of the dynamic cell "PlainCell"
        let cell = aTableView.dequeueReusableCell(withIdentifier: "AlgoTableViewCell", for: indexPath) as! AlgoTableViewCell
        
        let curAlgoName = curUser.algorithms.allKeys[indexPath.row] as! String
        
        let curAlgo = curUser.algorithms[curAlgoName ] as! NSDictionary
        
        cell.nameLabel!.text = curAlgoName
        cell.globe!.isHidden = curAlgo["running"] as! BooleanLiteralType
       
        if(curAlgo["public"] as! BooleanLiteralType){
            cell.shareButton!.setImage(UIImage(named: "Share Filled-50"), for: UIControlState.normal)
        } else {
            cell.shareButton!.setImage(UIImage(named: "Share-50"), for: UIControlState.normal)
        }
        
        
        // Return the configured cell
        return cell
    }
    
    func populateUserInfo(){
        nameLabel.text = curUser.firstName + " " + curUser.lastName
    }
    
    func configureImage(){
       // profileImageView.layer.borderWidth = 3
        profileImageView.layer.masksToBounds = false
        //profileImageView.layer.borderColor = UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0).cgColor
        
       // profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func configureFields(){
        
        nameLabel.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
        
        passwordField?.addTarget(self, action: #selector(ProfileViewController.passwordCheck), for: .editingChanged)
        
        reTypePasswordField?.addTarget(self, action: #selector(ProfileViewController.passwordCheck), for: .editingChanged)
        
        // UITextField Styling
        passwordField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        
        reTypePasswordField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
    }
    
    func passwordCheck(){
        
        // Check if algo has been changed
        if passwordField.text! != "" {
            
            passwordField.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
        } else {
            passwordField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        }
        
        if reTypePasswordField.text! != "" {
            
            reTypePasswordField.addBottomBorderWithColor(color: UIColor(hue: 359/360, saturation: 83/100, brightness: 76/100, alpha: 1.0), width: 2)
        } else {
            reTypePasswordField.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        }
    }
    
    @IBAction func algoHeaderClicked(_ sender: Any) {
        aTableView.isHidden = !aTableView.isHidden
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
