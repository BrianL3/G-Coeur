//
//  MenuController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/19/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class MenuController: UITableViewController, UITableViewDelegate, UITextFieldDelegate {

  @IBOutlet weak var repoTextField: UITextField!
  var repoSearch : String?

  

  
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.repoTextField.delegate = self
      
      // changing color
      self.view.backgroundColor = UIColor.lightGrayColor()

      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


  override func viewDidAppear(animated: Bool) {
    if NetworkController.sharedNetworkController.accessToken == nil {
      NetworkController.sharedNetworkController.requestAccessToken()
    }
    // to fix the zombie nav controller delegate problem
    self.navigationController?.delegate = nil
  }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SEARCH_REPO"{
      let destinationVC = segue.destinationViewController as RepositoryController
      destinationVC.incomingSearchTerm = self.repoTextField.text?
    }
    if segue.identifier == "SHOW_AUTH_USER"{
      println("fetch authenticated user about to fire in Menu Controller")
      let destinationVC = segue.destinationViewController as UserDetailController
    }

  }
  
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.repoSearch = repoTextField.text
    repoTextField.resignFirstResponder()
    let repoSearchVC = self.storyboard?.instantiateViewControllerWithIdentifier("REPO_SEARCH") as RepositoryController
    if repoTextField.text.validForURL(){
      repoSearchVC.incomingSearchTerm = repoTextField.text
    }
    self.navigationController?.pushViewController(repoSearchVC, animated: true)
    return true
  }
  


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
