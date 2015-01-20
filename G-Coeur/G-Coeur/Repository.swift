//
//  Repository.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/19/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import Foundation

struct Repository {
  
  let name : String!
  let ownerDict : [String : AnyObject]!
  let ownerID : String?
  let language : String!

  
  init(_ jsonDictionary : [String : AnyObject]){
    self.name = jsonDictionary["name"] as? String
    self.ownerDict = jsonDictionary["owner"] as? Dictionary
    self.ownerID = ownerDict["id"] as? String
    self.language = jsonDictionary["language"] as? String
    
//   self.name = itemsDict["]
}
  
}