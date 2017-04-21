//
//  ListViewController.swift
//  SustainLD
//
//  Created by Christopher Diaz on 4/4/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit
import FirebaseAuth

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rowHeight: CGFloat = 70
    let cellSpacingHeight: CGFloat = 15

    @IBOutlet weak var cityTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cityTable.rowHeight = rowHeight
        cityTable.delegate = self
        cityTable.dataSource = self
        //cityTable.sectionHeaderHeight = 100.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutClicked(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "firstNavigationController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return curUser.algorithms.allKeys.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        
        // Create an object of the dynamic cell "AlgoTableViewCell"
        let cell = cityTable.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        
        
        cell.cityNameLabel!.text = "Tempe, AZ"
        cell.cityRankLabel!.text = "1"
        
        
        // Return the configured cell
        return cell
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
