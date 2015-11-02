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
    if jsonDictionary["login"] != nil {
      self.login = jsonDictionary["login"] as! String
    }else{
      self.login = "failed to serialize"
    }
    if jsonDictionary["avatar_url"] != nil{
      self.avatarURL = NSURL(string: jsonDictionary["avatar_url"] as! String)
    }else{
      self.avatarURL = NSURL(string: "error")
    }
    if jsonDictionary["score"] != nil{
        self.score = jsonDictionary["score"] as! Float
    }else{
      self.score = 0.0
    }

  }
  
}

/*
[total_private_repos: 0, public_repos: 10, repos_url: https://api.github.com/users/BrianL3/repos, location: Seattle, WA, followers: 7, bio: <null>, organizations_url: https://api.github.com/users/BrianL3/orgs, type: User, blog: , starred_url: https://api.github.com/users/BrianL3/starred{/owner}{/repo}, owned_private_repos: 0, id: 9027758, name: Brian Ledbetter, following: 4, gists_url: https://api.github.com/users/BrianL3/gists{/gist_id}, following_url: https://api.github.com/users/BrianL3/following{/other_user}, updated_at: 2015-01-23T00:05:02Z, collaborators: 0, avatar_url: https://avatars.githubusercontent.com/u/9027758?v=3, gravatar_id: , url: https://api.github.com/users/BrianL3, followers_url: https://api.github.com/users/BrianL3/followers, created_at: 2014-10-05T17:39:34Z, private_gists: 0, disk_usage: 10344, company: , hireable: 0, login: BrianL3, site_admin: 0, public_gists: 0, received_events_url: https://api.github.com/users/BrianL3/received_events, email: , plan: {
collaborators = 0;
name = free;
"private_repos" = 0;
space = 307200;
}, subscriptions_url: https://api.github.com/users/BrianL3/subscriptions, events_url: https://api.github.com/users/BrianL3/events{/privacy}, html_url: https://github.com/BrianL3]
*/
