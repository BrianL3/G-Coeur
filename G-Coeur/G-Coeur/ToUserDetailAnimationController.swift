//
//  ToUserDetailAnimationController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/21/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class ToUserDetailAnimationController: NSObject , UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 1.0
  }
  
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    // reference the to- and from- ViewControllers
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SearchUsersController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailController
    
    //create a container view, the transition zone between VCs
    let containerView = transitionContext.containerView()
    
    //make the usual preparations for segue: pass the selected user, etc.
    let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as NSIndexPath
    let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCollectionViewCell
    toVC.user = fromVC.users[selectedIndexPath.row]
    
    //take a snapshot of the selected cell
    let snapshotOfCell = cell.avatarImage.snapshotViewAfterScreenUpdates(false)
    snapshotOfCell.frame = containerView.convertRect(cell.avatarImage.frame, fromView: cell.avatarImage.superview)
    // hide the cell
    cell.avatarImage.hidden = true
    
    //add the toVC to the screen, but hidden
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.alpha = 0
    toVC.avatarImageView.hidden = true
    toVC.nameLabel.hidden = true
    //adding
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshotOfCell)
    
    //give AutoLayout the opportunity to make any adjustments needed
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    // creating a placeholder for the duration
    let duration = self.transitionDuration(transitionContext)
    
    //==============
    //begin animation code
    // =============
    
    UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: nil, animations: { () -> Void in
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
        toVC.view.alpha = 0.5
        snapshotOfCell.center = containerView.center
        
      })
        UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
          toVC.view.alpha = 1.0
          let frame = containerView.convertRect(toVC.avatarImageView.frame, fromView: toVC.view)
          snapshotOfCell.frame = frame
        })
    }) { (finished) -> Void in
      
      toVC.avatarImageView.hidden = false
      toVC.nameLabel.hidden = false
      snapshotOfCell.removeFromSuperview()
      transitionContext.completeTransition(true)
      //unhide the original cell
      cell.avatarImage.hidden = false

    }
  }
  
}
