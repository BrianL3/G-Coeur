//
//  User.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/21/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit

struct User {
  let login : String!
  let avatarURL : NSURL!
  let score : Float!
  var image : UIImage?
  
  init(jsonDictionary: [String : AnyObject]){
    self.login = jsonDictionary["login"] as String
    self.avatarURL = NSURL(string: jsonDictionary["avatar_url"] as String)
    self.score = jsonDictionary["score"] as Float
  }
  
}
