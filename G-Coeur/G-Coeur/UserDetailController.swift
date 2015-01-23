//
//  UserDetailController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/21/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var user : User!
  var userRepos = [Repository]()
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var tableView: UITableView!
//MARK: ViewController Lifecycle
  
    override func viewDidLoad() {
      if self.user == nil{
        NetworkController.sharedNetworkController.fetchAuthenticatedUser({ (users, error) -> () in
          if error == nil{
            println("fetch authenticated user fired wihout error in Menu Controller")
            let userArray = users!
            var currentUser = userArray[0] as User
            NetworkController.sharedNetworkController.fetchUserAvatar(currentUser.avatarURL, completionHandler: { (image) -> Void in
              currentUser.image = image
            })
            self.user = currentUser
          }else{
            println("detailedUserview call to fetchAuthenticatedUser failed")
          }
        })
      }
        super.viewDidLoad()
      if self.user != nil {
        self.avatarImageView.image = user.image!
        self.nameLabel.text = user.login
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
      //set self as tableview delegate
      self.tableView.dataSource = self
      self.tableView.delegate = self
      
      // changing color
      self.view.backgroundColor = UIColor.lightGrayColor()
        

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
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("Row selected")
  }
  

    // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_REPO_FROM_USER"{
      let destinationVC = segue.destinationViewController as RepoDetailViewController
      let selectedIndexPath = self.tableView.indexPathsForSelectedRows()!.first as NSIndexPath
      let selectedRepo = userRepos[selectedIndexPath.row] as Repository
      destinationVC.url = selectedRepo.url
    }
}


}
