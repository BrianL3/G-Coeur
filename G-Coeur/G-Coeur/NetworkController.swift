//
//  NetworkController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/19/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit


class NetworkController{
  
  // Singleton for the network controller
  class var sharedNetworkController : NetworkController {
    struct Static {
      static let instance : NetworkController = NetworkController()
    }
    return Static.instance
  }
  
  var urlSession : NSURLSession!
  let clientSecret = "10da1bbdb897fd885734283e80cc6d67c4e1947c"
  let clientID = "ffa5ddfc3f169df9305d"
  let accessTokenUserDefaultsKey = "accessToken"
  var accessToken : String?
  
  let imageQueue = NSOperationQueue()

  
  init(){
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
    
    //when we initialize the Network Controller, check our standardUserDefaults to see if we already have an accessToken
    if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsKey) as? String {
      //println("successfully grabbed saved Access Token")
      self.accessToken = accessToken
    }

  }
//MARK: Requesting Auth Token
  func requestAccessToken() {
    let url = "https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo"
    
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    
  }

//MARK: PostRequest
  func handleCallbackURL(url: NSURL){
    
// METHOD 1: Passing info to Service Provider via parameters in the URL
    let code = url.query
    let oauthURL = "https://github.com/login/oauth/access_token?\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
    let postRequest = NSMutableURLRequest(URL: NSURL(string: oauthURL)!)
    postRequest.HTTPMethod = "POST"
    // println("check post request for malformed HTML: \(postRequest)")

//METHOD 2: is is the 2nd way you can pass back info with a POST, and this is passing back info in the Body of the HTTP Request
//    let bodyString = "\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
//    let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
//    let length = bodyData!.length
//    let postRequest = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
//    postRequest.HTTPMethod = "POST"
//    postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
//    postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//    postRequest.HTTPBody = bodyData
    
    let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
      //check&proceed if Service Provide returns nil for Error
      if error == nil{
        //check&proceed if we can form a NSHTTPURLResponse from Service provider's response
        if let httpResponse = response as? NSHTTPURLResponse{
        //build a switch on the response's status code
          switch httpResponse.statusCode{
          case 200...299:
            //println("Status 200 OK")
            let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
            //println("check where to split token response in order to get only the authToken: \(tokenResponse)")
            
            //splitting the token response
            let accessTokenComponent = tokenResponse?.componentsSeparatedByString("&").first as String
            let accessToken = accessTokenComponent.componentsSeparatedByString("=").last
            //println("Check Access Token \(accessToken)")
            
            //Save the AccessToken
            NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.accessTokenUserDefaultsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
          case 500...599:
            println("GitHub is down")
          default:
            println("hit default case")
            println(httpResponse.statusCode)
          }
        }
      }
    })
    dataTask.resume()
  }
//MARK: Search Methods
  func fetchRepositoriesForSearchTerm(searchTerm : String, completionHandler : ([Repository]?, String?) -> ()) {
    let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
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
            println("something broke in NetworkController fetching repo search terms")
            println("Status code was \(httpResponse.statusCode)")
          }
        }
        
      }
    })
    dataTask.resume()
    
    // A test URL, for pre-auth testing
    //let url = NSURL(string: "http://127.0.0.1:1337")
    // a test request, for pre-auth testing
    /*
    let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
    
    })
    dataTask.resume()
    */
  }
  
  func fetchReposForUser(userName: String, completionHandler: ([Repository]?, String?) -> Void){
    ///users/:username/repos
    let url = NSURL(string: "https://api.github.com/users/\(userName)/repos")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          var repos = [Repository]()
          switch httpResponse.statusCode {
          case 200...299:
            if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject]{
              for object in jsonArray{
                if let jsonDictionary = object as? [String : AnyObject]{
                  let repo = Repository(jsonDictionary)
                  repos.append(repo)
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
            println("something broke in NetworkController fetching repo search terms")
            println("Status code was \(httpResponse.statusCode)")
          }
        }
        
      }
    })
    dataTask.resume()

  }
  
// search for users with a name matching the searchTerm parameter
  func fetchUsersForSearchTerm(searchTerm: String, completionHandler : ([User]?, String?) -> Void){
    let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil{
        if let httpResponse = response as? NSHTTPURLResponse {
          var users = [User]()
          switch httpResponse.statusCode {
          case 200...299:
            if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              if let itemsArray = jsonDict["items"] as? [AnyObject]{
                for object in itemsArray{
                  if let jsonDict = object as? [String : AnyObject] {
                    let user = User(jsonDictionary: jsonDict)
                    users.append(user)
                  }
                }
              }
              
            }
            if (users.count > 0) {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(users, nil)
              })
            }else{
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(nil, "No search results returned")
              })
            }
          default:
            println("something broke in NetworkController fetching users")
            println("Status code was \(httpResponse.statusCode)")
          }
        }
      }else{
        let alert = UIAlertView(title: "Error", message: "Fetch Users for Search Term Returned an error!", delegate: self, cancelButtonTitle: "Shite!")
      }
    })
    dataTask.resume()
  }

  // fetch a user's image from the URL
  func fetchUserAvatar(url : NSURL, completionHandler : (image: UIImage?) -> Void){

    self.imageQueue.addOperationWithBlock { () -> Void in
      let data = NSData(contentsOfURL: url)
      let image = UIImage(data: data!)
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(image: image)
      })
    }
    
 
  }
  
}








