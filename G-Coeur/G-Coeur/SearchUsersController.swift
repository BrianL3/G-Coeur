//
//  SearchUsersController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/21/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class SearchUsersController:UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {
  //
  var users = [User]()
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  
//MARK: ViewController lyfecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // set delegates and datasources
    self.collectionView.dataSource = self
    self.searchBar.delegate = self
    self.navigationController?.delegate = self
    
    // changing color
    self.view.backgroundColor = UIColor.lightGrayColor()
  }
  
  
//MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as! UserCollectionViewCell
    var selectedUser = self.users[indexPath.row]
    cell.avatarImage.image = nil
    NetworkController.sharedNetworkController.fetchUserAvatar(selectedUser.avatarURL, completionHandler: { (image) -> Void in
      cell.avatarImage.image = image
      selectedUser.image = image
      self.users[indexPath.row] = selectedUser
    })
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }

//MARK: SearchBar Delegate
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    // fire network controller's search function
    guard let text = searchBar.text else {return}
    NetworkController.sharedNetworkController.fetchUsersForSearchTerm(text, completionHandler: { (users, error) -> Void in
      if error == nil{
        self.users = users!
        self.collectionView.reloadData()
      }else{
        print("returned an error in SearchUsersVC: \(error)")
      }
    })
  }
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validForURL()
  }
  //MARK: Prepare for Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationVC = segue.destinationViewController as! UserDetailController
    if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems()!.first {
        destinationVC.user = users[selectedIndexPath.row]
    }
    
  }
//MARK: NavigationBarDelegate
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if toVC is UserDetailController {
      return ToUserDetailAnimationController()
    }
    
    return nil
  }

}
