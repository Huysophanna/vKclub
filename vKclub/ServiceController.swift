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
//    var dashboardInstance = DashboardController()
    @IBOutlet weak var inKiriromContent: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    override func viewDidLoad() {
        
        //put proper content based on app mode
        print(CHCK_USER_LOCATION,"_+++mode1")
        if CHCK_USER_LOCATION == IN_KIRIROM {
            inKiriromContent.isHidden = false
            bottomLine.isHidden = false
        } else {
            inKiriromContent.isHidden = true
            bottomLine.isHidden = true
        }
    }
    
    @IBAction func GotoBookpage(_ sender: Any) {
         self.performSegue(withIdentifier: "SgGotoBookpage", sender: self)
    }
    
    @IBAction func CallToDepartmentAction(_ sender: Any) {
        if LinphoneManager.CheckLinphoneConnectionStatus() == false {
             PresentAlertController(title: "Something went wrong", message: "You are not connected to our server. Please ensure that you are connected to our network and try again later.", actionTitle: "Okay")
            return
            
        }
        
        switch (sender as! UIButton).tag {
            case 1:
                //reception
                if CHCK_USER_LOCATION == IN_KIRIROM {
                    CallToAction(phoneNumber: "235")
                } else {
                    //call using carrier phone number
                    guard let number = URL(string: "tel://" + "0962222735" ) else { return }
                    UIApplication.shared.open(number, options: [:], completionHandler: nil)
                }
                break
            case 2:
                //housekeeping
                CallToAction(phoneNumber: "236")
                break
            case 3:
                //massage
                CallToAction(phoneNumber: "237")
                break
            case 4:
                //pineviewkitchen
                CallToAction(phoneNumber: "238")
                break
            case 5:
                //activity
                CallToAction(phoneNumber: "239")
                break
            default:
                //operation
                CallToAction(phoneNumber: "240")
                break
        }
        
        
    }
    
    func CallToAction(phoneNumber: String) {
        IncomingCallController.dialPhoneNumber = phoneNumber
        self.incomingCallInstance.callToFlag = true
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
            noInternet.isHidden = true
        } else{
            self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
            return
        }
        let vkiriromurl : String = "http://vkirirom.com/en/reservation.php"
        let url = NSURL (string: vkiriromurl)
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
        if(error.localizedDescription == "The Internet connection appears to be offline."){
            noInternet.isHidden = false
            self.PresentAlertController(title: "Something went wrong", message: "Please Check you internet connection ", actionTitle: "Got it")
            UIComponentHelper.PresentActivityIndicatorWebView(view: self.view, option: false)
        }
        
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 }
