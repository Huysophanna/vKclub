//
//  ServiceController.swift
//  vKclub
//
//  Created by HuySophanna on 26/6/17.
//  Copyright © 2017 HuySophanna. All rights reserved.
//

import Foundation
import UIKit

class ServiceController: UIViewController {
    override func viewDidLoad() {
        
    }
    @IBAction func GotoBookpage(_ sender: Any) {
         self.performSegue(withIdentifier: "SgGotoBookpage", sender: self)
    }
 }
class BookingViewController: UIViewController ,UIWebViewDelegate{
    var propertyData: [String: AnyObject]!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var noInternet: UILabel!
    let internetConnection = InternetConnection()
    override func viewDidLoad() {
        super.viewDidLoad()
        if InternetConnection.isConnectedToNetwork() {
            noInternet.isHidden = true
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        
        let url = NSURL (string: "http://vkirirom.com/en/reservation.php")
        let requestObj = URLRequest(url: url! as URL)
        self.view.addSubview(webView)
        webView.delegate = self as UIWebViewDelegate
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        
        webView.loadRequest(requestObj)
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
        
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
        noInternet.isHidden = false
        self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
        
    }
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
 }
