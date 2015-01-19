//
//  NetworkController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/19/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import Foundation


class NetworkController{
  
  var urlSession : NSURLSession!

  
  init(){
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
  }
  
  func fetchRepositoriesForSearchTerm(searchTerm : String, completionHandler : ([Repository]?, String?) -> ()) {
    //let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let url = NSURL(string: "http://127.0.0.1:1337")
    
    let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          var repos = [Repository]()
          switch httpResponse.statusCode {
          case 200...299:
            if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              if let itemsArray = jsonDict["items"] as? [AnyObject]{
                for object in itemsArray{
                  if let jsonDict = object as? [String : AnyObject] {
                    let repo = Repository(jsonDict)
                    repos.append(repo)
                  }
                }
              }

            }
            if (repos.count > 0) {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(repos, nil)
              })
            }else{
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(nil, "No search results returned")
              })
            }
          default:
            println("something broke while feching repo search terms")
          }
        }

      }
    })
    dataTask.resume()
  }
  
  
  
}