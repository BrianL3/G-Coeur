//
//  RepoDetailViewController.swift
//  G-Coeur
//
//  Created by Brian Ledbetter on 1/22/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

import UIKit
import WebKit

class RepoDetailViewController: UIViewController {
  
  var url : NSURL?
  var webView : WKWebView!
  
//MARK: ViewController Lyfecycle
    override func viewDidLoad() {
      let rootView = UIView(frame: UIScreen.mainScreen().bounds)
      
      self.webView = WKWebView(frame: rootView.frame)

      self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
      rootView.addSubview(webView)
      let views = ["webView" : self.webView]
      // setting webview to autolayout to edge of screen (horizontral)
      let webViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: nil, metrics: nil, views: views)
      rootView.addConstraints(webViewConstraintHorizontal)
      // ditto but vertical
      let webViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: nil, metrics: nil, views: views)
      rootView.addConstraints(webViewConstraintVertical)
      

      
      let request = NSURLRequest(URL: self.url!)
      
      self.webView.loadRequest(request)
      
      self.view = rootView
        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(animated: Bool) {
    self.navigationController?.delegate = nil
  }
}
