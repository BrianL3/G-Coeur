//
//  UserCollectionViewCell.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/21/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var avatarImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.frame = self.bounds
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = 16.0
    }
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
}
