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
    var incomingCallInstance = IncomingCallController()
    
    @IBAction func GotoBookpage(_ sender: Any) {
         self.performSegue(withIdentifier: "SgGotoBookpage", sender: self)
    }
    
    @IBAction func CallToDepartmentAction(_ sender: Any) {
        
        switch (sender as! UIButton).tag {
            case 1:
                CallToAction(phoneNumber: "9999")
                break
            case 2:
                CallToAction(phoneNumber: "9999")
                break
            case 3:
                CallToAction(phoneNumber: "9999")
                break
            case 4:
                CallToAction(phoneNumber: "9999")
                break
            default:
                CallToAction(phoneNumber: "9999")
                break
        }
        
        
    }
    
    func CallToAction(phoneNumber: String) {
        self.incomingCallInstance.callToFlag = true
        IncomingCallController.dialPhoneNumber = phoneNumber
        LinphoneManager.makeCall(phoneNumber: phoneNumber)
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
            noInternet.alpha = 0
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
        let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
        UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
        noInternet.alpha = 1
        
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 }
