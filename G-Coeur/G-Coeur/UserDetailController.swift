//
//  UserDetailController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/21/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController, UITableViewDataSource {

  var user : User!
  var userRepos = [Repository]()
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarImageView.image = user.image!
        self.nameLabel.text = user.login
      
      //set self as tableview delegate
      self.tableView.dataSource = self
        
      //grab the user's repos
      NetworkController.sharedNetworkController.fetchReposForUser(user.login, completionHandler: { (repos, error) -> Void in
        if error == nil {
          self.userRepos = repos!
          self.tableView.reloadData()
        }else{
          println("returned an error")
        }

      })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: TableViewDataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as UITableViewCell
    let selectedRepo = userRepos[indexPath.row]
    cell.textLabel?.text = selectedRepo.name
    cell.detailTextLabel?.text = selectedRepo.language
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userRepos.count
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
