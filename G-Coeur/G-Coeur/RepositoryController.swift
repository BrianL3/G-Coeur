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
  
  var networkController : NetworkController!
  
  var repos = [Repository]()
  
  @IBOutlet weak var tableView: UITableView!
  
//MARK:ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    self.searchBar.delegate = self
    
    searchBar.text = self.incomingSearchTerm
    searchBar.becomeFirstResponder()
    
  }
  
  //MARK: TableViewDataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as UITableViewCell
    let repo = repos[indexPath.row]
    cell.textLabel?.text = repo.name
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
    networkController.fetchRepositoriesForSearchTerm(searchBar.text) { (returnedArray, error) -> () in
      if error == nil {
        println(searchBar.text)
        self.repos = returnedArray!
      }else{
        println("returned an error")
      }
    }
  }
  
}