//
//  RepositoryController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/19/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class RepositoryController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var incomingSearchTerm : String?
  
  var repos = [Repository]()
  
  @IBOutlet weak var tableView: UITableView!
  
//MARK:ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //setting delegates and datasources
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.searchBar.delegate = self
    
    //if we got a search term from the previous VC, load it up
    if incomingSearchTerm != nil {
      if incomingSearchTerm!.validForURL(){
      searchBar.text = self.incomingSearchTerm
      NetworkController.sharedNetworkController.fetchRepositoriesForSearchTerm(self.incomingSearchTerm!) { (returnedArray, error) -> () in
        if error == nil {
          println("fired")
          self.repos = returnedArray!
          self.tableView.reloadData()
        }else{
          println("returned an error")
        }
        }
      }
    } else {
      // if we didn't get a search term, make the search bar the first responder
      searchBar.becomeFirstResponder()
    }
    
  }
  
  //MARK: TableViewDataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as UITableViewCell
    let repo = repos[indexPath.row]
    cell.textLabel?.text = repo.name
    cell.detailTextLabel?.text = repo.language
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return repos.count
  }
  
  //MARK:TableViewDelegate
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
  }
  
  //MARK:SearchBar Delegate
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    tableView.reloadData()
    searchBar.resignFirstResponder()
    NetworkController.sharedNetworkController.fetchRepositoriesForSearchTerm(searchBar.text) { (returnedArray, error) -> () in
      if error == nil {
        println(searchBar.text)
        self.repos = returnedArray!
      }else{
        println("returned an error")
      }
    }
  }
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validForURL()
  }
  //prepare for segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_REPO"{
      let destinationVC = segue.destinationViewController as RepoDetailViewController
      let selectedIndexPath = self.tableView.indexPathsForSelectedRows()!.first as NSIndexPath
      let selectedRepo = repos[selectedIndexPath.row] as Repository
      destinationVC.url = selectedRepo.url
    }
  }
  
}